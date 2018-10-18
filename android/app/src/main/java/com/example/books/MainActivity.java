package com.example.books;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
//    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(
//            new MethodChannel.MethodCallHandler(){
//              @Override
//              public void onMethodCall(MethodCall methodCall,MethodChannel.Result result){
//                if(methodCall.method.equals("getBatteryLevel")){
//                  int batteryLevel = getBatteryLevel();
//                  if(batteryLevel != -1){
//                    result.success(batteryLevel);
//                  }else {
//                    result.error("error",null);
//                  }
//                }else {
//                  result.notImplemented();
//                }
//              }
//            }
//    );
  }

//  private int batteryLevel ;
//
//  private int getBatteryLevel() {
//
//    batteryLevel = -1;
//    if(Build.VERSION>SDK_INT>= Build.VERSION_CODES_LOLLIPOP){
//      BatteryManager batteryManager = (BatteryManager)getSystemService(BATTERY_SERVICE);
//      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
//    }else {
//      Intent intent = new ContextWrapper(getApplicationContext()).
//              registerReceiver(null,new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL,-1)*100)/intent.getIntExtra(BattreyManager.EXTRA_LEVEL);
//    }
//    return batteryLevel;
//  }
}
