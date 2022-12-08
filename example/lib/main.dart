import 'package:flutter/material.dart';
import 'package:gkash_payment/gkash_webview.dart';
import 'package:gkash_payment/model/payment_callback.dart';
import 'package:gkash_payment/model/payment_request.dart';
import 'package:gkash_payment/model/payment_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements PaymentCallback {
  String? amountInput = "0.10";
  final navigatorKey = GlobalKey<NavigatorState>();
  String? _status = "",
      _cartId = "",
      _amount = "",
      _currency = "",
      _poId = "",
      _paymentType = "",
      _description = "",
      _cid = "";

  @override
  void getPaymentStatus(PaymentResponse response) {
    setState(() {
      _status = response.status;
      _cartId = response.cartid;
      _amount = response.amount;
      _currency = response.currency;
      _description = response.description;
      _paymentType = response.PaymentType;
      _poId = response.POID;
      _cid = response.cid;
    });
  }

  requestPayment() {
    PaymentRequest request = PaymentRequest(
        version: '1.5.0',
        cid: "M102-U-xxx",
        currency: 'MYR',
        amount: amountInput,
        cartid: DateTime.now().millisecondsSinceEpoch.toString(),
        signatureKey: "yourSignatureKey",
        paymentCallback: this);

    Navigator.of(navigatorKey.currentState!.context).push(
      MaterialPageRoute(
        builder: (_) {
          return GkashWebView(request);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("GkashPayment"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
                onChanged: (amount) {
                  amountInput = amount;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "Amount",
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = "";
                      _cartId = "";
                      _amount = "";
                      _currency = "";
                      _description = "";
                      _paymentType = "";
                      _poId = "";
                      _cid = "";
                    });
                    requestPayment();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('SUBMIT'),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Text("Status: ${_status!}"),
                  Text("Description: ${_description!}"),
                  Text("POID: ${_poId!}"),
                  Text("Cid: ${_cid!}"),
                  Text("CartId: ${_cartId!}"),
                  Text("Amount: ${_currency! + _amount!}"),
                  Text("PaymentType: ${_paymentType!}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
