# GkashFlutterSDK

This plugin allows you to integrate Gkash Payment Gateway into your Flutter App.

## Usage

Sample usage to start a payment:

```
import 'package:gkash_payment/gkash_webview.dart';
import 'package:gkash_payment/model/payment_callback.dart';
import 'package:gkash_payment/model/payment_request.dart';
import 'package:gkash_payment/model/payment_response.dart';

    requestPayment() {
        //Generate your Payment Request
        PaymentRequest request = PaymentRequest(
            version: '1.5.0',
            cid: "M102-U-xxx",
            currency: 'MYR',
            amount: amountInput,
            cartid: DateTime.now().millisecondsSinceEpoch.toString(),
            signatureKey: "yourSignatureKey",
            isProd: false, //if production environment then set to true
            callbackUrl: "https://YourCallbackUrl.com/callback", //set your callback URL (Optional)
            paymentCallback: this);
        //Navigate to GkashWebView
        Navigator.of(navigatorKey.currentState!.context).push(
            MaterialPageRoute(
                builder: (_) {
                return GkashWebView(request);
                },
            ),
        );
    }
```

## Getting the Payment Result

Upon finishing of the WebView Activity, implement GkashPaymentCallback to your widget

```
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements PaymentCallback {

  @override
  void getPaymentStatus(PaymentResponse response) {
    // handle payment response
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
```
## IOS 
Fos IOS, you need to add URL schemes to get your transaction status and pass your URL scheme to GkashPaymentSDK

Apps can declare any custom URL schemes they support. Use the URL Types section of the Info tab to specify the custom URL schemes that your app handles.
![Screenshot 2022-09-12 at 1 04 17 PM](https://user-images.githubusercontent.com/72077476/189577588-53a41833-3c4d-47b5-ab5a-6e755787fc8d.png)


## License
[Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)