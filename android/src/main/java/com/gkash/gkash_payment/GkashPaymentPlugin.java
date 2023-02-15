package com.gkash.gkash_payment;

import android.app.Activity;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.gkash.gkashandroidsdk.GkashPayment;
import com.gkash.gkashandroidsdk.PaymentRequest;
import com.gkash.gkashandroidsdk.PaymentResponse;
import com.gkash.gkashandroidsdk.TransStatusCallback;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/** GkashPaymentPlugin */
public class GkashPaymentPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel mChannel;
  private Activity mActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    mChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gkash_payment");
    mChannel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("requestPayment")){
      String amt = call.argument("amount");
      BigDecimal amount = new BigDecimal(amt);
      PaymentRequest request = new PaymentRequest(call.argument("version"), call.argument("cid"),
              call.argument("signatureKey"), call.argument("currency"), amount,
              call.argument("cartid"), new TransStatusCallback() {
        @Override
        public void onStatusCallback(PaymentResponse paymentResponse) {
          Map <String, String> resp = new HashMap<>();
          resp.put("description", paymentResponse.description);
          resp.put("cid", paymentResponse.CID);
          resp.put("POID", paymentResponse.POID);
          resp.put("currency", paymentResponse.currency);
          resp.put("amount", paymentResponse.amount.toString());
          resp.put("cartid", paymentResponse.cartid);
          resp.put("PaymentType", paymentResponse.PaymentType);
          resp.put("status", paymentResponse.status);
          result.success(resp);
        }
      });
      request.setCallbackUrl(call.argument("callbackUrl"));
      final GkashPayment gkashPayment = GkashPayment.getInstance();
      boolean isProd = call.argument("isProd") == null ? false : call.argument("isProd");
      gkashPayment.setProductionEnvironment(isProd);
      gkashPayment.startPayment(mActivity, request);
    }else{
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    mChannel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    mActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
