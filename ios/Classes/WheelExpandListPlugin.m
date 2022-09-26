#import "WheelExpandListPlugin.h"
#if __has_include(<wheel_expand_list/wheel_expand_list-Swift.h>)
#import <wheel_expand_list/wheel_expand_list-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wheel_expand_list-Swift.h"
#endif

@implementation WheelExpandListPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWheelExpandListPlugin registerWithRegistrar:registrar];
}
@end
