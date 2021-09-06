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

namespace {
    std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>, std::default_delete<flutter::MethodChannel<flutter::EncodableValue>>> channel = nullptr;

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
        channel =
            std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                registrar->messenger(), "screen_retriever",
                &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<ScreenRetrieverPlugin>();

        channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto& call, auto result)
        {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

        registrar->AddPlugin(std::move(plugin));
    }


    ScreenRetrieverPlugin::ScreenRetrieverPlugin() { }

    ScreenRetrieverPlugin::~ScreenRetrieverPlugin() { }

    void ScreenRetrieverPlugin::_EmitEvent(std::string eventName) {
        flutter::EncodableMap args = flutter::EncodableMap();
            args[flutter::EncodableValue("eventName")] = flutter::EncodableValue(eventName);
        channel->InvokeMethod("onEvent", std::make_unique<flutter::EncodableValue>(args));
    }

    HWND ScreenRetrieverPlugin::GetMainWindow() {
        return ::GetAncestor(registrar->GetView()->GetNativeWindow(), GA_ROOT);
    }

    void ScreenRetrieverPlugin::GetCursorScreenPoint(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        result->NotImplemented();
    }

    void ScreenRetrieverPlugin::GetPrimaryDisplay(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        result->NotImplemented();
    }
    
    void ScreenRetrieverPlugin::GetAllDisplays(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        result->NotImplemented();
    }

    void ScreenRetrieverPlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (method_call.method_name().compare("getCursorScreenPoint") == 0) {
            GetCursorScreenPoint(method_call, std::move(result));
        }
        else if (method_call.method_name().compare("getPrimaryDisplay") == 0) {
            GetPrimaryDisplay(method_call, std::move(result));
        }
        else if (method_call.method_name().compare("getAllDisplays") == 0) {
            GetAllDisplays(method_call, std::move(result));
        }
        else {
            result->NotImplemented();
        }
    }

} // namespace

void ScreenRetrieverPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
    ScreenRetrieverPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
        ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
