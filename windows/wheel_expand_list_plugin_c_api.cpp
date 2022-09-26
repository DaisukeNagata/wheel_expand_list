#include "include/wheel_expand_list/wheel_expand_list_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "wheel_expand_list_plugin.h"

void WheelExpandListPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  wheel_expand_list::WheelExpandListPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
