#ifndef FLUTTER_PLUGIN_SCREEN_RETRIEVER_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_SCREEN_RETRIEVER_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace screen_retriever_windows {

class ScreenRetrieverWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  ScreenRetrieverWindowsPlugin();

  virtual ~ScreenRetrieverWindowsPlugin();

  // Disallow copy and assign.
  ScreenRetrieverWindowsPlugin(const ScreenRetrieverWindowsPlugin&) = delete;
  ScreenRetrieverWindowsPlugin& operator=(const ScreenRetrieverWindowsPlugin&) =
      delete;

  void ScreenRetrieverWindowsPlugin::GetCursorScreenPoint(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ScreenRetrieverWindowsPlugin::GetPrimaryDisplay(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void ScreenRetrieverWindowsPlugin::GetAllDisplays(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace screen_retriever_windows

#endif  // FLUTTER_PLUGIN_SCREEN_RETRIEVER_WINDOWS_PLUGIN_H_
