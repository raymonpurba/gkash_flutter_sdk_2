import UIKit
import GkashPayment
import Flutter
import SwiftUI
import WebKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("AppDelegate: logging.")
    GeneratedPluginRegistrant.register(with: self)
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let _methodChannel : FlutterMethodChannel = FlutterMethodChannel(name: "gkash_payment", binaryMessenger: controller.binaryMessenger)
        
        print("AppDelegate: " + url.absoluteURL.absoluteString)
        
        var status : String = getQueryStringParameter(url: url.absoluteString, param: "status") ?? "Unknown status"
        status = status.replacingOccurrences(of: "+", with: " ")
        let description : String = getQueryStringParameter(url: url.absoluteString, param: "description") ?? ""
        let CID : String = getQueryStringParameter(url: url.absoluteString, param: "CID") ?? ""
        let POID : String = getQueryStringParameter(url: url.absoluteString, param: "POID") ?? ""
        let cartid : String = getQueryStringParameter(url: url.absoluteString, param: "cartid") ?? ""
        let amount : String = getQueryStringParameter(url: url.absoluteString, param: "amount") ?? ""
        let currency : String = getQueryStringParameter(url: url.absoluteString, param: "currency") ?? ""
        var PaymentType : String = getQueryStringParameter(url: url.absoluteString, param: "PaymentType") ?? ""
        PaymentType = PaymentType.replacingOccurrences(of: "+", with: " ")
        let signature : String = getQueryStringParameter(url: url.absoluteString, param: "signature") ?? ""
        let resp : PaymentResponse = PaymentResponse(Status: status, Amount: amount, CartId: cartid, Description: description, Currency: currency, POID: POID, CID: CID, PaymentType: PaymentType)
//        if(resp.validateSignature(signature: signature, request: resp)){
//      //    callback!.getStatus(response: resp)
//        }else{
//          resp.status = "11 - Pending"
//          resp.description = "Invalid Signature"
//        //  callback!.getStatus(response: resp)
//        }
        
        var jsonString : String? = "default data"
        do {
        let encodedData = try JSONEncoder().encode(resp)
            jsonString = String(data: encodedData, encoding: .utf8)
        }catch {
            print(error)
        }
        
        _methodChannel.invokeMethod("getPaymentStatus", arguments: jsonString);
        return true
        }
}

private func getQueryStringParameter(url: String, param: String) -> String? {
   guard let url = URLComponents(string: url) else { return nil }
   return url.queryItems?.first(where: { $0.name == param })?.value
  }
