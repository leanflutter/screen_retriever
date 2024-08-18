//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hotkey_manager/hotkey_manager_plugin.h>
#include <screen_retriever_windows/screen_retriever_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  HotkeyManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HotkeyManagerPlugin"));
  ScreenRetrieverWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverWindowsPluginCApi"));
}
