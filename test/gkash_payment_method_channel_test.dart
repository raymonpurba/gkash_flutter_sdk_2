import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gkash_payment/gkash_payment_method_channel.dart';

void main() {
  MethodChannelGkashPayment platform = MethodChannelGkashPayment();
  const MethodChannel channel = MethodChannel('gkash_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
