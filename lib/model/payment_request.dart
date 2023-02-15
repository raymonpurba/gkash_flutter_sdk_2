import 'package:gkash_payment/model/payment_callback.dart';

class PaymentRequest {
  final String? version;
  final String? cid;
  final String? currency;
  final String? amount;
  final String? cartid;
  final String? signatureKey;
  String? returnUrl; //URL scheme
  final String? callbackUrl;
  final String? email; // Optional
  final String? mobileNo; // Optional
  final String? firstName; // Optional
  final String? lastName; // Optional
  final String? productDescription; // Optional
  final String? billingStreet; // Optional
  final String? billingPostCode; // Optional
  final String? billingCity; // Optional
  final String? billingState; // Optional
  final String? billingCountry; // Optional
  final bool isProd;
  final PaymentCallback? paymentCallback;

  bool getIsProd() {
    return isProd;
  }

  String? getVersion() {
    return version;
  }

  String? getCid() {
    return cid;
  }

  String? getCurrency() {
    return currency;
  }

  String? getAmount() {
    return amount;
  }

  String? getCartId() {
    return cartid;
  }

  String? getEmail() {
    return email;
  }

  String? getMobileNo() {
    return mobileNo;
  }

  String? getFirstName() {
    return firstName;
  }

  String? getLastName() {
    return lastName;
  }

  String? getSignatureKey() {
    return signatureKey;
  }

  String? getProductDescription() {
    return productDescription;
  }

  String? getBillingStreet() {
    return billingStreet;
  }

  String? getBillingPostCode() {
    return billingPostCode;
  }

  String? getBillingCity() {
    return billingCity;
  }

  String? getBillingState() {
    return billingState;
  }

  String? getBillingCountry() {
    return billingCountry;
  }

  String? getReturnURL() {
    return returnUrl;
  }

  void setReturnURL(String returnURL) {
    returnUrl = returnURL;
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'cid': cid,
      'currency': currency,
      'amount': amount,
      'cartid': cartid,
      'signatureKey': signatureKey,
      'returnUrl': returnUrl,
      'email': email,
      'mobileNo': mobileNo,
      'firstName': firstName,
      'lastName': lastName,
      'productDescription': productDescription,
      'billingStreet': billingStreet,
      'billingPostCode': billingPostCode,
      'billingCity': billingCity,
      'billingState': billingState,
      'billingCountry': billingCountry,
      'callbackUrl': callbackUrl,
      'isProd': isProd
    };
  }

  PaymentRequest(
      {required this.version,
      required this.cid,
      required this.currency,
      required this.amount,
      required this.cartid,
      required this.signatureKey,
      this.callbackUrl,
      this.returnUrl,
      this.email,
      this.mobileNo,
      this.firstName,
      this.lastName,
      this.productDescription,
      this.billingStreet,
      this.billingPostCode,
      this.billingCity,
      this.billingState,
      this.billingCountry,
      required this.isProd,
      this.paymentCallback});
}
