import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:gkash_payment/gkash_payment.dart';
import 'package:gkash_payment/gkash_payment_platform_interface.dart';
import 'package:gkash_payment/gkash_payment_method_channel.dart';
import 'package:gkash_payment/model/payment_request.dart';
import 'package:gkash_payment/model/payment_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGkashPaymentPlatform 
    with MockPlatformInterfaceMixin
    implements GkashPaymentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<PaymentResponse> requestPayment(PaymentRequest request) {
    // TODO: implement requestPayment
    throw UnimplementedError();
  }
}

void main() {
  final GkashPaymentPlatform initialPlatform = GkashPaymentPlatform.instance;

  test('$MethodChannelGkashPayment is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGkashPayment>());
  });

  test('getPlatformVersion', () async {
    GkashPayment gkashPaymentPlugin = GkashPayment();
    MockGkashPaymentPlatform fakePlatform = MockGkashPaymentPlatform();
    GkashPaymentPlatform.instance = fakePlatform;
  
    expect(await gkashPaymentPlugin.getPlatformVersion(), '42');
  });
}
