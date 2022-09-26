//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <wheel_expand_list/wheel_expand_list_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) wheel_expand_list_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WheelExpandListPlugin");
  wheel_expand_list_plugin_register_with_registrar(wheel_expand_list_registrar);
}
