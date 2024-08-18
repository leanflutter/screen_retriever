#include "include/screen_retriever_linux/screen_retriever_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "screen_retriever_linux_plugin_private.h"

#define SCREEN_RETRIEVER_LINUX_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), screen_retriever_linux_plugin_get_type(), \
                              ScreenRetrieverLinuxPlugin))

FlEventChannel* event_channel;

struct _ScreenRetrieverLinuxPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(ScreenRetrieverLinuxPlugin,
              screen_retriever_linux_plugin,
              g_object_get_type())

// Called when a method call is received from Flutter.
static void screen_retriever_linux_plugin_handle_method_call(
    ScreenRetrieverLinuxPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  FlValue* args = fl_method_call_get_args(method_call);
  if (strcmp(method, "getCursorScreenPoint") == 0) {
    response = get_cursor_screen_point(self, args);
  } else if (strcmp(method, "getPrimaryDisplay") == 0) {
    response = get_primary_display(self, args);
  } else if (strcmp(method, "getAllDisplays") == 0) {
    response = get_all_displays(self, args);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlValue* monitor_to_flvalue(GdkMonitor* monitor) {
  GdkRectangle frame;
  gdk_monitor_get_geometry(monitor, &frame);

  auto size = fl_value_new_map();
  fl_value_set_string_take(size, "width", fl_value_new_float(frame.width));
  fl_value_set_string_take(size, "height", fl_value_new_float(frame.height));

  GdkRectangle workarea_rect;
  gdk_monitor_get_workarea(monitor, &workarea_rect);

  // printf("x: %d y: %%d", workarea_rect.x, workarea_rect.y);

  auto visible_size = fl_value_new_map();
  fl_value_set_string_take(visible_size, "width",
                           fl_value_new_float(workarea_rect.width));
  fl_value_set_string_take(visible_size, "height",
                           fl_value_new_float(workarea_rect.height));

  auto visible_position = fl_value_new_map();
  fl_value_set_string_take(visible_position, "dx",
                           fl_value_new_float(workarea_rect.x));
  fl_value_set_string_take(visible_position, "dy",
                           fl_value_new_float(workarea_rect.y));

  const char* name = gdk_monitor_get_model(monitor);
  gint scale_factor = gdk_monitor_get_scale_factor(monitor);

  auto value = fl_value_new_map();
  fl_value_set_string_take(value, "id", fl_value_new_string(""));
  fl_value_set_string_take(value, "name",
                           fl_value_new_string(name == nullptr ? "" : name));
  fl_value_set_string_take(value, "size", size);
  fl_value_set_string_take(value, "visibleSize", visible_size);
  fl_value_set_string_take(value, "visiblePosition", visible_position);
  fl_value_set_string_take(value, "scaleFactor",
                           fl_value_new_float(scale_factor));

  return value;
}

FlMethodResponse* get_cursor_screen_point(ScreenRetrieverLinuxPlugin* self,
                                          FlValue* args) {
  GdkDisplay* display = gdk_display_get_default();
  GdkSeat* seat = gdk_display_get_default_seat(display);
  GdkDevice* pointer = gdk_seat_get_pointer(seat);

  int x, y;
  gdk_device_get_position(pointer, NULL, &x, &y);

  g_autoptr(FlValue) result_data = fl_value_new_map();
  fl_value_set_string_take(result_data, "dx", fl_value_new_float(x));
  fl_value_set_string_take(result_data, "dy", fl_value_new_float(y));

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result_data));
}

FlMethodResponse* get_primary_display(ScreenRetrieverLinuxPlugin* self,
                                      FlValue* args) {
  GdkDisplay* display = gdk_display_get_default();
  GdkMonitor* monitor = gdk_display_get_primary_monitor(display);

  // opt: fallback if there's no primary monitor
  if (monitor == nullptr) {
    int monitor_count = gdk_display_get_n_monitors(display);
    if (monitor_count == 0) {
      return nullptr;
    } else {
      monitor = gdk_display_get_monitor(display, 0);
    }
  }
  g_autoptr(FlValue) result_data = monitor_to_flvalue(monitor);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result_data));
}

FlMethodResponse* get_all_displays(ScreenRetrieverLinuxPlugin* self,
                                   FlValue* args) {
  auto displays = fl_value_new_list();

  GdkDisplay* display = gdk_display_get_default();
  gint n_monitors = gdk_display_get_n_monitors(display);
  for (gint i = 0; i < n_monitors; i++) {
    GdkMonitor* monitor = gdk_display_get_monitor(display, i);
    fl_value_append_take(displays, monitor_to_flvalue(monitor));
  }

  g_autoptr(FlValue) result_data = fl_value_new_map();
  fl_value_set_string_take(result_data, "displays", displays);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result_data));
}

static void screen_retriever_linux_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(screen_retriever_linux_plugin_parent_class)->dispose(object);
}

static void screen_retriever_linux_plugin_class_init(
    ScreenRetrieverLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = screen_retriever_linux_plugin_dispose;
}

static void screen_retriever_linux_plugin_init(
    ScreenRetrieverLinuxPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel,
                           FlMethodCall* method_call,
                           gpointer user_data) {
  ScreenRetrieverLinuxPlugin* plugin = SCREEN_RETRIEVER_LINUX_PLUGIN(user_data);
  screen_retriever_linux_plugin_handle_method_call(plugin, method_call);
}

static void emit_event(FlEventChannel* event_channel, const gchar* name) {
  g_autoptr(FlValue) event = fl_value_new_map();
  fl_value_set_string_take(event, "type", fl_value_new_string(name));
  fl_event_channel_send(event_channel, event, nullptr, nullptr);
}

static void monitor_added_cb(FlEventChannel* event_channel) {
  emit_event(event_channel, "display-added");
}

static void monitor_removed_cb(FlEventChannel* event_channel) {
  emit_event(event_channel, "display-removed");
}

void screen_retriever_linux_plugin_register_with_registrar(
    FlPluginRegistrar* registrar) {
  ScreenRetrieverLinuxPlugin* plugin = SCREEN_RETRIEVER_LINUX_PLUGIN(
      g_object_new(screen_retriever_linux_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "dev.leanflutter.plugins/screen_retriever", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, g_object_ref(plugin), g_object_unref);

  g_autoptr(FlStandardMethodCodec) event_codec = fl_standard_method_codec_new();
  event_channel =
      fl_event_channel_new(fl_plugin_registrar_get_messenger(registrar),
                           "dev.leanflutter.plugins/screen_retriever_event",
                           FL_METHOD_CODEC(event_codec));

  GdkDisplay* display = gdk_display_get_default();
  g_signal_connect_object(display, "monitor-added",
                          G_CALLBACK(monitor_added_cb), event_channel,
                          G_CONNECT_SWAPPED);
  g_signal_connect_object(display, "monitor-removed",
                          G_CALLBACK(monitor_removed_cb), event_channel,
                          G_CONNECT_SWAPPED);

  g_object_unref(plugin);
}
