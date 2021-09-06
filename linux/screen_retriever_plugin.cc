#include "include/screen_retriever/screen_retriever_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#define SCREEN_RETRIEVER_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), screen_retriever_plugin_get_type(), \
                              ScreenRetrieverPlugin))

struct _ScreenRetrieverPlugin
{
  GObject parent_instance;
  FlPluginRegistrar *registrar;
};

G_DEFINE_TYPE(ScreenRetrieverPlugin, screen_retriever_plugin, g_object_get_type())

// Gets the window being controlled.
GtkWindow *get_window(ScreenRetrieverPlugin *self)
{
  FlView *view = fl_plugin_registrar_get_view(self->registrar);
  if (view == nullptr)
    return nullptr;

  return GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

GdkWindow *get_gdk_window(ScreenRetrieverPlugin *self)
{
  return gtk_widget_get_window(GTK_WIDGET(get_window(self)));
}

static FlMethodResponse *get_cursor_screen_point(ScreenRetrieverPlugin *self,
                                                 FlValue *args)
{
  return FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
}

static FlMethodResponse *get_primary_display(ScreenRetrieverPlugin *self,
                                             FlValue *args)
{
  return FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
}

static FlMethodResponse *get_all_displays(ScreenRetrieverPlugin *self,
                                          FlValue *args)
{
  return FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
}

// Called when a method call is received from Flutter.
static void screen_retriever_plugin_handle_method_call(
    ScreenRetrieverPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);
  if (strcmp(method, "getCursorScreenPoint") == 0)
  {
    response = get_cursor_screen_point(self, args);
  }
  else if (strcmp(method, "getPrimaryDisplay") == 0)
  {
    response = get_primary_display(self, args);
  }
  else if (strcmp(method, "getAllDisplays") == 0)
  {
    response = get_all_displays(self, args);
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void screen_retriever_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(screen_retriever_plugin_parent_class)->dispose(object);
}

static void screen_retriever_plugin_class_init(ScreenRetrieverPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = screen_retriever_plugin_dispose;
}

static void screen_retriever_plugin_init(ScreenRetrieverPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  ScreenRetrieverPlugin *plugin = SCREEN_RETRIEVER_PLUGIN(user_data);
  screen_retriever_plugin_handle_method_call(plugin, method_call);
}

void screen_retriever_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  ScreenRetrieverPlugin *plugin = SCREEN_RETRIEVER_PLUGIN(
      g_object_new(screen_retriever_plugin_get_type(), nullptr));

  plugin->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "screen_retriever",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
