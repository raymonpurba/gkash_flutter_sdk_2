import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gkash_payment_method_channel.dart';
import 'model/payment_request.dart';
import 'model/payment_response.dart';

abstract class GkashPaymentPlatform extends PlatformInterface {
  /// Constructs a GkashPaymentPlatform.
  GkashPaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static GkashPaymentPlatform _instance = MethodChannelGkashPayment();

  /// The default instance of [GkashPaymentPlatform] to use.
  ///
  /// Defaults to [MethodChannelGkashPayment].
  static GkashPaymentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GkashPaymentPlatform] when
  /// they register themselves.
  static set instance(GkashPaymentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<PaymentResponse> requestPayment(PaymentRequest request) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
