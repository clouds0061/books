import 'package:books/home_page/HomePageNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SplashPage.dart';
import 'package:books/home_page/HomePage.dart';
import 'package:books/home_page/HomePageIOS.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:books/utils/CommonUtils.dart';
import 'package:umeng/umeng.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  CommonUtils.setScreenOrientation(CommonUtils.oriUpAndDown);
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown]
//  ).then((a){
////    runApp(new MyApp());
//    print('成功设置屏幕方向 ');
//  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final DeviceInfoPlugin infoPlugin = new DeviceInfoPlugin();
  String name = '';
  @override
  Widget build(BuildContext context) {
    initUmeng();
    return new MaterialApp(
      title: '',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: Platform.isIOS == true ? new HomePageIOS() : new HomePage(), //正常选择入口
      home: new HomePageNew(),//测试入口
//      routes: <String,WidgetBuilder>{
//        '/HomePage':(BuildContext context)=>new HomePage()
//      },
    );
  }
// This widget is the root of your application.

  void initUmeng() async{
 //   String res = await Umeng.initUm('5bc44da0f1f556a593000135');//android
//      res = await Umeng.initUmIos("5bc569f3f1f556e25a000245", "");//ipad
//    String res = await Umeng.initUmIos("5bc3ef79f1f55675130000af", "");//iPhone
    if(Platform.isAndroid){
      String res = await Umeng.initUm('5bc44da0f1f556a593000135');//android
      print(res);
    }
  }

  //获取设备信息
  Future<String> initDeviceName() async {
    try {
      name = (await infoPlugin.iosInfo).model;
    } catch (Exception) {
      name = 'Failed to get device name';
    } finally {
//      setState(() {});
    }
    return name;
  }

}
