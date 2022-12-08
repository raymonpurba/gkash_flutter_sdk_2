import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gkash_payment_platform_interface.dart';
import 'model/payment_request.dart';
import 'model/payment_response.dart';

/// An implementation of [GkashPaymentPlatform] that uses method channels.
class MethodChannelGkashPayment extends GkashPaymentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gkash_payment');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<PaymentResponse> requestPayment(PaymentRequest request) async {
    // var resp =
    //     await methodChannel.invokeMethod('requestPayment', request.toMap());
    // PaymentResponse response = PaymentResponse.fromJson(resp);
    // return response;
    var response =
        await methodChannel.invokeMethod('requestPayment', request.toMap());
    PaymentResponse paymentStatus = PaymentResponse.fromJson(response);
    return paymentStatus;
  }
}
