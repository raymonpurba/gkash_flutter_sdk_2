import 'gkash_payment_platform_interface.dart';
import 'model/payment_request.dart';
import 'model/payment_response.dart';

class GkashPayment {
  Future<String?> getPlatformVersion() {
    return GkashPaymentPlatform.instance.getPlatformVersion();
  }

  Future<PaymentResponse> requestPayment(PaymentRequest request) {
    return GkashPaymentPlatform.instance.requestPayment(request);
  }
}
