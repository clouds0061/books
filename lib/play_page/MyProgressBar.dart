import 'dart:async';

import 'package:books/utils/CommonUtils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:books/play_page/Progress.dart';
import 'package:books/play_page/PlayPage.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class MyProgressBar extends StatefulWidget {
  num _max_progress;
  num _current_progress;
  _ProgressBar _progressBar;

  Function setFlag;

  void setProgress(num current_progress,num max_progress) {
    this._current_progress = current_progress;
    _progressBar.setProgress(current_progress,max_progress);
  }

  bool getFlag() {
    return _progressBar.getFlag();
  }

  MyProgressBar(this._max_progress, this._current_progress, this.setFlag);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    _progressBar = new _ProgressBar(_max_progress, _current_progress, setFlag);
    return _progressBar;
  }
}

class _ProgressBar extends State<MyProgressBar> {
  num _max_progress;

  num _current_progress;
  Function setFlag;
  var name;
  final DeviceInfoPlugin infoPlugin = new DeviceInfoPlugin();

  bool flag_play = true; //是否播放  true为正在播放 false为暂停

  void setProgress(num progress,num max_progress) {
    setState(() {
      this._current_progress = progress;
      this._max_progress = max_progress;
    });
  }

  bool getFlag() {
    return this.flag_play;
  }

  _ProgressBar(this._max_progress, this._current_progress, this.setFlag);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeviceName();
  }

  //获取设备信息
  Future<Null> initDeviceName() async {
    try {
      name = (await infoPlugin.iosInfo).model;
    } catch (Exception) {
      name = 'Failed to get device name';
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)..init(context);
    print('设备型号为:$name');
    if (CommonUtils.isIPad(name)) {
      ScreenUtil.instance = new ScreenUtil(width: 2048, height: 1536)
        ..init(context); //首先默认是手机端。
    } else {
      ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
        ..init(context); //首先默认是手机端。
    }
    // TODO: implement build\
    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
              width: double.infinity,
              child: new Container(
                alignment: FractionalOffset.bottomCenter,
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(52)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            flag_play = !flag_play;
                          });
                          setFlag(flag_play);
                        },
                        child: Image.asset(
                          flag_play == true
                              ? 'images/pause.png'
                              : 'images/play.png',
                          fit: BoxFit.fill,
                          width: CommonUtils.isIPad(name) == true
                              ? 38.0
                              : ScreenUtil().setWidth(60),
                          height: CommonUtils.isIPad(name) == true
                              ? 38.0
                              : ScreenUtil().setHeight(60),
                        ),
                      ),
                    ),
                    new CustomPaint(
                        painter: Progress(
                            Colors.black,
                            Colors.lightBlueAccent,
                            Colors.blue,
                            _current_progress,
                            _max_progress,
                            Colors.black),
                        size: CommonUtils.isIPad(name) == true
                            ? Size(ScreenUtil().setWidth(1497),
                                ScreenUtil().setHeight(16))
                            : Size(ScreenUtil().setWidth(520),
                                ScreenUtil().setHeight(16))),
                    new Container(
                      width: CommonUtils.isIPad(name) == true
                          ? ScreenUtil().setWidth(164)
                          : ScreenUtil().setWidth(84),
                      height: ScreenUtil().setHeight(24),
                      margin: EdgeInsets.only(left: 0.0, bottom: CommonUtils.isIPad(name)==true?12.0:3.0),
                      child: new Center(
                        child: new Text(
                          '${_current_progress}/$_max_progress',
                          style: TextStyle(
                              fontSize: CommonUtils.isIPad(name) == true
                                  ? 22.0
                                  : 12.0,
                              color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              )),
//          new Align(
//            alignment: FractionalOffset.bottomRight,
//            child: new Container(
//              padding: EdgeInsets.only(bottom: 17.0,right: 20.0),
//              child: new Text(
//                '${_current_progress}/$_max_progress',
//                style: TextStyle(fontSize: 10.0),
//              ),
//            ),
//          )
        ],
      ),
    );
//      return new Container(
////        child: new LinearProgressIndicator(
////          value: 0.4,
////          backgroundColor: Colors.black12,
////        ),
//      );
  }
}
