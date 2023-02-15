import Flutter
import UIKit
import GkashPayment
import SwiftUI
import WebKit
public class SwiftGkashPaymentPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gkash_payment", binaryMessenger: registrar.messenger())
    let instance = SwiftGkashPaymentPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(WebViewFactory(messenger: registrar.messenger()), withId: "GkashFluffView")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     
      if ("getPlatformVersion" == call.method) {
          result("iOS " + UIDevice.current.systemVersion)
      }
  }

    public class WebViewFactory : NSObject, FlutterPlatformViewFactory{
    private var messenger: FlutterBinaryMessenger
      
      init(messenger: FlutterBinaryMessenger) {
              self.messenger = messenger
              super.init()
          }
        
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) ->
        FlutterPlatformView {
        return FlutterWebView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
  }

  class FlutterWebView: NSObject , FlutterPlatformView, WKNavigationDelegate, TransStatusCallback {
    private var _nativeWebView: WKWebView
    private var _methodChannel: FlutterMethodChannel
    private var request : PaymentRequest? = nil
      
  init(
      frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?,
      binaryMessenger messenger: FlutterBinaryMessenger
  ) {
      let data = args as? [String: Any]
    //  let data = args as? Dictionary<String, Any>
      let cid : String = data?["cid"] as! String? ?? ""
      let amount : String = data?["amount"] as! String? ?? ""
      let signatureKey : String = data?["signatureKey"] as! String? ?? ""
      let cartId : String = data?["cartId"] as! String? ?? ""
      let isProd : Bool = data?["isProd"] as! Bool? ?? false
      let returnUrl : String = data?["returnUrl"] as! String? ?? ""
      let firstName : String = data?["v_firstname"] as! String? ?? ""
      let lastName : String = data?["v_lastname"] as! String? ?? ""
      let callbackUrl : String = data?["callbackUrl"] as! String? ?? ""
      _nativeWebView = WKWebView()
      _methodChannel = FlutterMethodChannel(name: "gkash_payment", binaryMessenger: messenger)
      let urlScheme = URL(string: "gkash://returntoapp")

      super.init()

      request = PaymentRequest(cid: cid, signatureKey: signatureKey, amount: amount, cartId: cartId, isProd: isProd, returnUrl: returnUrl, callback: self)
    
      let url: String = request!.HOST_URL + "/api/PaymentForm.aspx"
      print("update ui view")
 
      var urlRequest: URLRequest = URLRequest(url: URL(string: url)!)
      urlRequest.httpMethod = "POST"
      urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      var components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: false)!
      components.queryItems = [
        URLQueryItem(name: "version", value: request!.version),
        URLQueryItem(name: "CID", value: request!.cid),
        URLQueryItem(name: "v_currency", value: request!.currency),
        URLQueryItem(name: "v_amount", value: request!.amount),
        URLQueryItem(name: "v_cartid", value: request!.cartId),
        URLQueryItem(name: "v_firstname", value: request!.firstName),
        URLQueryItem(name: "v_lastname", value: request!.lastName),
        URLQueryItem(name: "v_billemail", value: request!.email),
        URLQueryItem(name: "v_billphone", value: request!.mobileNo),
        URLQueryItem(name: "signature", value: request!.generateSignature()),
        URLQueryItem(name: "returnurl", value: request!.returnUrl),
        URLQueryItem(name: "callbackurl", value: callbackUrl),
      ]
      let query = components.url!.query
      urlRequest.httpBody = Data(query!.utf8)
      _nativeWebView.load(urlRequest)
      
      self._nativeWebView.navigationDelegate = self
      // iOS views can be created heres
  }
    
      
    public func getStatus(response: PaymentResponse) {
        var jsonString : String? = "default data"
        do {
        let encodedData = try JSONEncoder().encode(response)
            jsonString = String(data: encodedData, encoding: .utf8)
        }catch {
            print(error)
        }
        
        _methodChannel.invokeMethod("getPaymentStatus", arguments: jsonString);
    }
    
    func view() -> UIView {
        return _nativeWebView
    }
      
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    // Suppose you don't want your user to go a restricted site
    // Here you can get many information about new url from 'navigationAction.request.description'
    let url = navigationAction.request.url?.absoluteString
    print(url ?? "url is null")
      for item in request!.walletScheme{
      if (url?.contains(item) ?? false){
        print("walletScheme: " + url!)
        let schemeURL = URL(string: url!)
        if UIApplication.shared.canOpenURL(schemeURL!)
        {
          if url?.contains(request!.returnUrl) ?? false {
              print("StatusCallback")
              request!.StatusCallback(url: navigationAction.request.url!)
          }else{
              print("launch")
              UIApplication.shared.open(schemeURL!)
          }
          decisionHandler(.cancel)
          return
        }
      }
        
    }
    // This allows the navigation
    decisionHandler(.allow)
    }
  }
}
