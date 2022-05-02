#include "include/screen_retriever/screen_retriever_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <codecvt>
#include <map>
#include <memory>
#include <sstream>

const double kBaseDpi = 96.0;

namespace {
std::unique_ptr<
    flutter::MethodChannel<flutter::EncodableValue>,
    std::default_delete<flutter::MethodChannel<flutter::EncodableValue>>>
    channel = nullptr;

class ScreenRetrieverPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  ScreenRetrieverPlugin();

  virtual ~ScreenRetrieverPlugin();

 private:
  flutter::PluginRegistrarWindows* registrar;

  void ScreenRetrieverPlugin::_EmitEvent(std::string eventName);

  HWND ScreenRetrieverPlugin::GetMainWindow();
  void ScreenRetrieverPlugin::GetCursorScreenPoint(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ScreenRetrieverPlugin::GetPrimaryDisplay(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ScreenRetrieverPlugin::GetAllDisplays(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void ScreenRetrieverPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "screen_retriever",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ScreenRetrieverPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ScreenRetrieverPlugin::ScreenRetrieverPlugin() {}

ScreenRetrieverPlugin::~ScreenRetrieverPlugin() {}

void ScreenRetrieverPlugin::_EmitEvent(std::string eventName) {
  flutter::EncodableMap args = flutter::EncodableMap();
  args[flutter::EncodableValue("eventName")] =
      flutter::EncodableValue(eventName);
  channel->InvokeMethod("onEvent",
                        std::make_unique<flutter::EncodableValue>(args));
}

HWND ScreenRetrieverPlugin::GetMainWindow() {
  return ::GetAncestor(registrar->GetView()->GetNativeWindow(), GA_ROOT);
}

flutter::EncodableMap MonitorToEncodableMap(HMONITOR monitor) {
  std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;

  MONITORINFOEX info;
  info.cbSize = sizeof(MONITORINFOEX);
  ::GetMonitorInfo(monitor, &info);
  UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);

  wchar_t display_name[sizeof(info.szDevice) / sizeof(*info.szDevice) + 1];
  memset(display_name, 0, sizeof(display_name));
  memcpy(display_name, info.szDevice, sizeof(info.szDevice));

  double scale_factor = dpi / kBaseDpi;

  double visibleWidth = (info.rcWork.right - info.rcWork.left);
  double visibleHeight = (info.rcWork.bottom - info.rcWork.top);

  double visibleX = (info.rcWork.left);
  double visibleY = (info.rcWork.top);

  flutter::EncodableMap size = flutter::EncodableMap();
  flutter::EncodableMap visibleSize = flutter::EncodableMap();
  flutter::EncodableMap visiblePosition = flutter::EncodableMap();

  size[flutter::EncodableValue("width")] =
      flutter::EncodableValue(static_cast<double>(info.rcMonitor.right));
  size[flutter::EncodableValue("height")] =
      flutter::EncodableValue(static_cast<double>(info.rcMonitor.bottom));

  visibleSize[flutter::EncodableValue("width")] =
      flutter::EncodableValue(visibleWidth);
  visibleSize[flutter::EncodableValue("height")] =
      flutter::EncodableValue(visibleHeight);

  visiblePosition[flutter::EncodableValue("x")] =
      flutter::EncodableValue(visibleX);
  visiblePosition[flutter::EncodableValue("y")] =
      flutter::EncodableValue(visibleY);

  flutter::EncodableMap display = flutter::EncodableMap();

  display[flutter::EncodableValue("id")] = flutter::EncodableValue(0);
  display[flutter::EncodableValue("name")] =
      flutter::EncodableValue(converter.to_bytes(display_name).c_str());
  display[flutter::EncodableValue("size")] = flutter::EncodableValue(size);
  display[flutter::EncodableValue("visibleSize")] =
      flutter::EncodableValue(visibleSize);
  display[flutter::EncodableValue("visiblePosition")] =
      flutter::EncodableValue(visiblePosition);
  display[flutter::EncodableValue("scaleFactor")] =
      flutter::EncodableValue(scale_factor);

  return display;
}

BOOL CALLBACK MonitorRepresentationEnumProc(HMONITOR monitor,
                                            HDC hdc,
                                            LPRECT clip,
                                            LPARAM list_ref) {
  flutter::EncodableValue* monitors =
      reinterpret_cast<flutter::EncodableValue*>(list_ref);
  flutter::EncodableMap display = MonitorToEncodableMap(monitor);
  std::get<flutter::EncodableList>(*monitors).push_back(display);
  return TRUE;
}

void ScreenRetrieverPlugin::GetCursorScreenPoint(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const flutter::EncodableMap& args =
      std::get<flutter::EncodableMap>(*method_call.arguments());

  double device_pixel_ratio =
      std::get<double>(args.at(flutter::EncodableValue("devicePixelRatio")));

  double x, y;
  POINT cursorPos;
  GetCursorPos(&cursorPos);
  x = cursorPos.x / device_pixel_ratio * 1.0f;
  y = cursorPos.y / device_pixel_ratio * 1.0f;

  flutter::EncodableMap result_data = flutter::EncodableMap();
  result_data[flutter::EncodableValue("x")] = flutter::EncodableValue(x);
  result_data[flutter::EncodableValue("y")] = flutter::EncodableValue(y);

  result->Success(flutter::EncodableValue(result_data));
}

void ScreenRetrieverPlugin::GetPrimaryDisplay(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  POINT ptZero = {0, 0};
  HMONITOR monitor = MonitorFromPoint(ptZero, MONITOR_DEFAULTTOPRIMARY);
  flutter::EncodableMap display = MonitorToEncodableMap(monitor);
  result->Success(flutter::EncodableValue(display));
}

void ScreenRetrieverPlugin::GetAllDisplays(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  flutter::EncodableValue displays(std::in_place_type<flutter::EncodableList>);

  ::EnumDisplayMonitors(nullptr, nullptr, MonitorRepresentationEnumProc,
                        reinterpret_cast<LPARAM>(&displays));

  flutter::EncodableMap result_data = flutter::EncodableMap();
  result_data[flutter::EncodableValue("displays")] = displays;

  result->Success(result_data);
}

void ScreenRetrieverPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getCursorScreenPoint") == 0) {
    GetCursorScreenPoint(method_call, std::move(result));
  } else if (method_call.method_name().compare("getPrimaryDisplay") == 0) {
    GetPrimaryDisplay(method_call, std::move(result));
  } else if (method_call.method_name().compare("getAllDisplays") == 0) {
    GetAllDisplays(method_call, std::move(result));
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void ScreenRetrieverPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ScreenRetrieverPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
