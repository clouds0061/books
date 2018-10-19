import 'dart:async';

import 'package:books/play_page/PlayPageInPadHor.dart';
import 'package:flutter/material.dart';
import 'package:books/home_page/bookListView.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wechat/flutter_wechat.dart';
import 'package:books/play_page/PlayPage.dart';
import 'package:books/play_page/PlayPageNew.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:books/utils/CommonUtils.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'dart:ui';
import 'package:umeng/umeng.dart';

import 'package:device_info/device_info.dart';

class HomePageIOS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageIOS();
  }
}

///
/// 主页 IOS
class _HomePageIOS extends State<HomePageIOS> {
  final DeviceInfoPlugin infoPlugin = new DeviceInfoPlugin();
  String name = '';
  num ori = CommonUtils.oriUpAndDown;
  var size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('这是ios操作系统');
    initDeviceName();
    FlutterWechat.registerWechat('wx33a7aafbd16d1820');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    onEnd();//页面结束
  }

  //获取设备信息
  Future<String> initDeviceName() async {
    try {
      name = (await infoPlugin.iosInfo).model;
    } catch (Exception) {
      name = 'Failed to get device name';
    } finally {
      setState(() {
        if (CommonUtils.isIPad(name)) {
          initUmeng(1);
        }else{
          initUmeng(2);
        }
      });
    }
    return name;
  }

  void initUmeng(int i) async{
    //   String res = await Umeng.initUm('5bc44da0f1f556a593000135');//android
//      res = await Umeng.initUmIos("5bc569f3f1f556e25a000245", "");//ipad
//    String res = await Umeng.initUmIos("5bc3ef79f1f55675130000af", "");//iPhone
    if(i==1){
      String res = await Umeng.initUmIos("5bc569f3f1f556e25a000245", "");//ipad
      print('iPad:$res');
    }else{
      String res = await Umeng.initUmIos("5bc3ef79f1f55675130000af", "");//iPhone
      print('iPhone:$res');
    }
  }

  void onEvent(String eventId) async{
    String res = await Umeng.onEvent(eventId);
  }

  void onStart() async{
    String res = await Umeng.onPageStart('首页');
  }

  void onEnd() async{
    String res = await Umeng.onPageEnd('首页');
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    setState(() {});
//    ori = CommonUtils.oriUpAndDown;
    print('设备型号为:$name');
//    if()
    if (CommonUtils.isIPad(name)) {
//      initUmeng(1);
      var screen = MediaQuery
          .of(context)
          .size;
      print('屏幕信息:$screen');
      if (CommonUtils.screenIsVertical(size)) {
        ScreenUtil.instance = new ScreenUtil(width: 1553, height: 2048)
          ..init(context); //首先默认是pad端。
      } else {
        ScreenUtil.instance = new ScreenUtil(width: 2048, height: 1553)
          ..init(context); //首先默认是pad端。
      }
    } else {
//      initUmeng(2);
      ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
        ..init(context); //首先默认是手机端。

    }
    if (CommonUtils.isIPad(name)) ori = CommonUtils.oriUp;
    try {
      CommonUtils.setScreenOrientation(ori);
    } catch (Exception) {
      print('出错啦：$Exception');
    }
    onStart();//首页开始
    return new MaterialApp(
        title: '',
        home: new Scaffold(
            appBar: null,
//          appBar: new AppBar(
//              title: new Container(
//            decoration: new BoxDecoration(
//                image: new DecorationImage(image: new AssetImage(''))),
//            child: new Center(
//              child: new Text('儿童绘本之我爸爸'),
//            ),
//          )),
            body: new Container(
                width: double.infinity,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('images/bg.png'),
                        fit: BoxFit.fill)),
                height: double.infinity,
                child: new Column(
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(top: 35.0, bottom: 10.0),
                          child: new Center(
                              child: new Text(
                                  '儿童绘本之我妈妈',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                      CommonUtils.isIPad(name) == true
                                          ? 26.5
                                          : 16.5),
                                  ),
                              ),
                          ),
                      new Align(
                      //图书开始阅读按钮
                          alignment: FractionalOffset.center,
                          child: new Container(
                              width: CommonUtils.isIPad(name) == true
                                  ? ScreenUtil().setWidth(1476)
                                  : ScreenUtil().setWidth(690),
                              height: CommonUtils.isIPad(name) == true
                                  ? CommonUtils.screenIsVertical(size)==true?
                          ScreenUtil().setHeight(1100): ScreenUtil().setHeight(900)
                          : ScreenUtil().setHeight(800),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: new DecorationImage(
                                      image: new AssetImage('images/mom.png'),
                                      fit: BoxFit.fill),
                                  ),
                              child: new Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    new Align(
                                    //分享按钮
                                        child: new Container(
                                            width: ScreenUtil().setWidth(100),
                                            height: ScreenUtil().setHeight(128),
                                            margin: EdgeInsets.only(top: 15.0),
                                            child: new Column(
                                                children: <Widget>[
                                                  new IconButton(
                                                      padding: EdgeInsets.only(
                                                          top: 0.0),
                                                      icon: new Image(
                                                          image: new AssetImage(
                                                              'images/share.png'),
                                                          fit: BoxFit.fill),
                                                      onPressed: () async {
                                                        onEvent('20181015001');
                                                        await FlutterWechat
                                                            .shareText(
                                                            text: '微信分享',
                                                            type: 0);
                                                      },
                                                      ),
//                                    new Text(
//                                      '分享',
//                                      style: TextStyle(fontSize: 20.0),
//                                    ),
                                                ],
                                                ),
                                            ),
                                        alignment: FractionalOffset.topRight,
                                        ),
                                    new Expanded(
                                        child: new GestureDetector(
                                            onTap: () async {
                                              onEvent('play');//点击了paly按钮 进入播放页面
                                              onEnd();//此页面结束
                                              setState(() {
                                                CommonUtils.isIPad(name)
                                                    ? ori = CommonUtils
                                                    .oriLeft //如果是Pad跳转到Pad横屏模式
                                                    : ori =
                                                    CommonUtils.oriUpAndDown;
                                              });
//                                  CommonUtils.setScreenOrientation(CommonUtils.oriLeftAndRight);
                                              //点击播放后 跳转进入播放页面
                                              print('点击了开始播放');
                                              await Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (
                                                          BuildContext context) {
                                                        return CommonUtils
                                                            .isIPad(name)
                                                            ? new PlayPageInPadHor() //如果是Pad跳转到Pad横屏模式
                                                            : new PlayPageNew();
                                                      })).then((result) {
                                                setState(() {
                                                  ori = result;
                                                });
                                              });
                                            },
                                            child: new Container(
                                                alignment: FractionalOffset
                                                    .center,
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: new Image.asset(
                                                    'images/go2play.png',
                                                    width: CommonUtils.isIPad(
                                                        name) == true
                                                        ? ScreenUtil().setWidth(
                                                        323)
                                                        : ScreenUtil().setWidth(
                                                        149),
                                                    height: CommonUtils.isIPad(
                                                        name) == true
                                                        ? ScreenUtil()
                                                        .setHeight(273)
                                                        : ScreenUtil()
                                                        .setHeight(149),
                                                    fit: BoxFit.fill,
                                                    ),
                                                ),
                                            ),
                                        )
                                  ],
                                  )
//                      new GestureDetector(
//                        onTap: () async {
//                          //点击播放后 跳转进入播放页面
//                          print('点击了开始播放');
//                          await Navigator.push(context, new MaterialPageRoute(
//                              builder: (BuildContext context) {
//                                return new PlayPageNew();
//                              }));
//                        },
//                        child: new Container(
//                          padding: EdgeInsets.symmetric(vertical: 100.0),
//                          child: new Image.asset('images/icons.png'),
//                        ),
//                      ),
                          )),
                      new Flexible(
                      //其他图书的列表 列表中点击子项 跳转到appstore中去下载其他图书app
                          child: new Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: new Container(
                                  margin: EdgeInsets.only(
                                      bottom: CommonUtils.isIPad(name) == true
                                          ? CommonUtils.screenIsVertical(
                                          size) == true ?
                                      ScreenUtil().setHeight(184) : ScreenUtil()
                                          .setHeight(0)
                                          : ScreenUtil().setHeight(89),
                                      left: CommonUtils.isIPad(name) == true
                                          ? ScreenUtil().setWidth(0)
                                          : ScreenUtil().setWidth(15)),
                                  height: CommonUtils.isIPad(name) == true
                                      ? ScreenUtil().setHeight(590)
                                      : ScreenUtil().setHeight(280),
                                  decoration: new BoxDecoration(color: null),
                                  child: new BookListView(name),
                                  ),
                              ),
                          ),
                    ],
                    ),
                ),
            ));
    // TODO: implement build
  }
}
