import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkash_payment/gkash_payment_platform_interface.dart';
import 'model/payment_response.dart';
import 'model/payment_request.dart';

class GkashWebView extends StatefulWidget {
  final PaymentRequest request;
  const GkashWebView(this.request, {Key? key}) : super(key: key);

  @override
  State<GkashWebView> createState() => _GkashWebViewState();
}

class _GkashWebViewState extends State<GkashWebView> {
  final Map<String, dynamic> creationParams = <String, dynamic>{};
  final _platform = const MethodChannel('gkash_payment');

  getPaymentStatus() async {
    _platform.setMethodCallHandler((call) async {
      try {
        if (call.arguments == "default data") {
          return;
        }
        Map<String, dynamic> valueMap = json.decode(call.arguments);
        PaymentResponse resp = PaymentResponse.fromJson(valueMap);
        widget.request.paymentCallback?.getPaymentStatus(resp);
        Navigator.of(context).pop();
      } catch (e) {
        return;
      }
    });
  }

  validateRequest() {
    if (widget.request.getAmount() == null) {
      throw ("Parameter amount is required.");
    } else {
      try {
        double.parse(widget.request.getAmount()!);
      } catch (e) {
        throw ("Parameter amount is invalid.");
      }
    }
    if (widget.request.getVersion() == null ||
        widget.request.getVersion()!.isEmpty) {
      throw ("Parameter version is required.");
    }
    if (widget.request.getCid() == null || widget.request.getCid()!.isEmpty) {
      throw ("Parameter cid is required.");
    }
    if (widget.request.getCurrency() == null ||
        widget.request.getCurrency()!.isEmpty) {
      throw ("Parameter currency is required.");
    }
    if (widget.request.getCartId() == null ||
        widget.request.getCartId()!.isEmpty) {
      throw ("Parameter cartId is required.");
    }
    if (widget.request.getSignatureKey() == null ||
        widget.request.getSignatureKey()!.isEmpty) {
      throw ("Parameter signatureKey is required.");
    }
    if (widget.request.getReturnURL() == null ||
        widget.request.getReturnURL()!.isEmpty) {
      widget.request.setReturnURL("gkash://returntoapp");
    }
  }

  @override
  void initState() {
    getPaymentStatus();
    validateRequest();
    if (Platform.isIOS) {
      creationParams['amount'] = widget.request.amount;
      creationParams['signatureKey'] = widget.request.signatureKey;
      creationParams['email'] = widget.request.email;
      creationParams['cartId'] = widget.request.cartid;
      creationParams['cid'] = widget.request.cid;
      creationParams['currency'] = widget.request.currency;
      creationParams['firstName'] = widget.request.firstName;
      creationParams['lastName'] = widget.request.lastName;
      creationParams['returnUrl'] =
          widget.request.returnUrl ?? "gkash://returntoapp";
      creationParams['isProd'] = widget.request.isProd.toString();
      creationParams['callbackUrl'] = widget.request.callbackUrl.toString();
    } else {
      GkashPaymentPlatform gkashPayment = GkashPaymentPlatform.instance;
      gkashPayment.requestPayment(widget.request).then((resp) {
        widget.request.paymentCallback?.getPaymentStatus(resp);
        Navigator.of(context).pop();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gkash Payment"),
      ),
      body: Platform.isIOS
          ? Container(
              color: Colors.white,
              child: UiKitView(
                viewType: 'GkashFluffView',
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              ),
            )
          : Container(),
    );
  }
}
