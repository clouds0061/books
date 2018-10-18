import 'package:flutter/material.dart';
import 'package:books/home_page/bookListView.dart';
import 'package:flutter_wechat/flutter_wechat.dart';
import 'package:books/play_page/PlayPage.dart';
import 'package:books/play_page/PlayPageNew.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:books/utils/CommonUtils.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePage();
  }
}

///
/// 主页
class _HomePage extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    CommonUtils.setScreenOrientation(CommonUtils.oriUpAndDown);
    FlutterWechat.registerWechat('wx33a7aafbd16d1820');
    print('Android---');
  }

  @override
  Widget build(BuildContext context) {
      ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
        ..init(context);
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
                    image: new AssetImage('images/bg.png'), fit: BoxFit.fill)),
            height: double.infinity,
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 35.0, bottom: 10.0),
                  child: new Center(
                    child: new Text(
                      '儿童绘本之我妈妈',
                      style: TextStyle(color: Colors.white, fontSize: 16.5),
                    ),
                  ),
                ),
                new Align(
                    //图书开始阅读按钮
                    alignment: FractionalOffset.center,
                    child: new Container(
                        width: ScreenUtil().setWidth(690),
                        height: ScreenUtil().setHeight(800),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: new DecorationImage(
                              image: new AssetImage('images/mom.png'),
                              fit: BoxFit.fill),
                        ),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      padding: EdgeInsets.only(top: 0.0),
                                      icon: new Image(
                                          image: new AssetImage(
                                              'images/share.png'),
                                          fit: BoxFit.fill),
                                      onPressed: () async {
                                        await FlutterWechat.shareText(
                                            text: '微信分享', type: 0);
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
                                  //点击播放后 跳转进入播放页面
                                  print('点击了开始播放');
                                  await Navigator.push(context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return new PlayPageNew();
                                  }));
                                },
                                child: new Container(
                                  alignment: FractionalOffset.center,
                                  width:  ScreenUtil().setWidth(149),
                                  height: ScreenUtil().setHeight(149),
                                  child: new Image.asset(
                                    'images/go2play.png',
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
                          bottom: ScreenUtil().setHeight(80),
                          left: ScreenUtil().setWidth(15)),
                      height:  ScreenUtil().setHeight(280),
                      decoration: new BoxDecoration(color: null),
                      child: new BookListView(''),
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
