#import "GkashPaymentPlugin.h"
#if __has_include(<gkash_payment/gkash_payment-Swift.h>)
#import <gkash_payment/gkash_payment-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gkash_payment-Swift.h"
#endif

@implementation GkashPaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGkashPaymentPlugin registerWithRegistrar:registrar];
}
@end
