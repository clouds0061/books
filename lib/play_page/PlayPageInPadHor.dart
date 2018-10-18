import 'package:books/utils/CommonUtils.dart';
import 'package:flutter/material.dart';
import 'package:books/play_page/MyProgressBar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:async';
import 'package:quiver/time.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:books/play_page/MyProgressBar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:books/utils/FileUtils.dart';
import 'package:books/utils/AudioUtils.dart';
import 'package:umeng/umeng.dart';

class PlayPageInPadHor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayInPad();
}

class _PlayInPad extends State<PlayPageInPadHor> with TickerProviderStateMixin {
  PlayPageControl control; //控制按钮
  bool _flag_hide = false; //是否显示播放控制组件 true是隐藏 false是显示

  Timer timer;
  List<ImageProvider> imageList = new List(); //放需要播放的图片
  List<String> stringList = new List(); //放需要暂时的文字
  num _startPosition = 0;
  num _movePosition = 0;
  var _max_pageV = 21; //最大页数 因为是从0开始的 所以31也的漫画在这里最大页数是30
  var _max_pageH = 11; //最大页数 因为是从0开始的 所以31也的漫画在这里最大页数是30
  int indexV = 0; //播放的页数
  int indexH = 0; //播放的页数
  Ticker _ticker; //计时器 用来几时
  Ticker fadeTicker; //自动淡出计时器
  bool _flag = true; //是否暂停
  bool _oriVer = null; //是否是竖屏

  AnimationController controller; //动画控制器
  CurvedAnimation curvedAnimation; //动画
  MyProgressBar myProgressBarH ;
  MyProgressBar myProgressBarV ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    control = new PlayPageControl();
    myProgressBarH = new MyProgressBar(21, indexH + 1, _setFlag);
    myProgressBarV = new MyProgressBar(11, indexV + 1, _setFlag);

    timer = new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _flag_hide = !_flag_hide;
      });
    });

    initAnimation(); //初始化动画
    initImage(); //初始化图片
    _PlayPage(); //初始化图片播放计时器
    fadeTickers(); //初始化淡入淡出效果计时器
    CommonUtils.initString(stringList);
//    CommonUtils.setScreenOrientation(CommonUtils.oriLeftAndRight);
  }

  void onStart() async{
    String res = await Umeng.onPageStart('播放页面');
  }

  void onEnd() async{
    String res = await Umeng.onPageEnd('播放页面');
  }

  void onEvent(String eventId) async{
    String res =await Umeng.onEvent(eventId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_ticker.isTicking) {
      _ticker.stop(canceled: true);
      _ticker.dispose();
    }
    if (fadeTicker.isTicking) {
      fadeTicker.stop(canceled: true);
      fadeTicker.dispose();
    }
    ;
    if (timer.isActive) timer.cancel();
    super.dispose();
    onEnd();
  }

  void _setFlag(bool flag) {
    setState(() {
      _flag = flag;
      _ticker.stop();
    });
  }

  //初始化动画
  void initAnimation() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    curvedAnimation =
    new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
//        setState(() {
//          _flag_hide = !_flag_hide;
//        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _flag_hide = !_flag_hide;
        });
      }
    });
//    controller.forward();
  }

  //初始化图片
  void initImage() {
//    imageList.add(new AssetImage('images/imageA1.jpg'));
//    imageList.add(new AssetImage('images/imageA2.jpg'));
    for (int i = 0; i < 11 * 2 - 1; i++) {
      //image1 -  image21
      var num = i + 1;
      imageList.add(new AssetImage('images/image$num.jpg'));
    }
//    imageList.add(new AssetImage('images/imageA3.jpg'));
  }

  //初始化计时器
  _PlayPage() {
    _ticker = new Ticker((Duration d) {
      //建立计时器。没*秒让index++;
      //5秒一次切换
      if (d.inSeconds % 5 == 0 && d.inSeconds >= 5) {
        _ticker.stop(canceled: true);
        setState(() {
          if(CommonUtils.screenIsVertical(size)){
            indexV++;
          }else{
            indexH++;
          }
//          indexV++;
//          indexH++;
          CommonUtils.screenIsVertical(size)==false?
          myProgressBarV.setProgress(indexH + 1, 11):
          myProgressBarH.setProgress(indexV + 1, 21);
        });
      }
    });
  }

  //自动淡出计时器
  void fadeTickers() {
    fadeTicker = new Ticker((Duration d) {
      //4秒后 界面控制组件自动淡出
      if (d.inSeconds % 4 == 0 && d.inSeconds >= 4) {
        fadeTicker.stop(canceled: true);
        controller.forward();
        anim_flag = !anim_flag;
      }
    });
  }


  //设置播放图片 竖屏
  ImageProvider setImageVer() {
    if (!_ticker.isTicking && _flag) if (indexV < _max_pageV)
      _ticker.start(); //在没有计时器并且不是,还有不是最后一页手动换页的暂停状态下要开始新的计时
//    print('index增长到了$index');
    if (indexV >= _max_pageV) {
      indexV = _max_pageV;
      _ticker.stop(canceled: true);
    }
//
//    if (!_flag) {
//      //手动换页几面 不播放音乐
//      AudioUtils.getAudioUtils().setPlayer(audioPlayer).pauseAudio();
//    } else {
//      if (index < _max_page) {
//        AudioUtils.getAudioUtils().setPlayer(audioPlayer).pauseAudio();
//        AudioUtils.getAudioUtils().setPlayer(audioPlayer).stopAudio();
//        AudioUtils.getAudioUtils()
//            .setPlayer(audioPlayer)
//            .playAudio(audioPath[(index % 2 == 0 ? 0 : 1)]);
//      }
//    }
//
//    if (index >= _max_page)
//      AudioUtils.getAudioUtils()
//          .setPlayer(audioPlayer)
//          .stopAudio(); //最后一页封面暂停音乐
    return imageList[indexV];
  }

  //设置播放图片
  ImageProvider setImage(num i) {
    if (!_ticker.isTicking && _flag) if (indexH < _max_pageH)
      _ticker.start(); //在没有计时器并且不是,还有不是最后一页手动换页的暂停状态下要开始新的计时
//    print('index增长到了$index');
    if (indexH >= _max_pageH) {
      indexH = _max_pageH - 1;
      _ticker.stop(canceled: true);
    }
//
//    if (!_flag) {
//      //手动换页几面 不播放音乐
//      AudioUtils.getAudioUtils().setPlayer(audioPlayer).pauseAudio();
//    } else {
//      if (index < _max_page) {
//        AudioUtils.getAudioUtils().setPlayer(audioPlayer).pauseAudio();
//        AudioUtils.getAudioUtils().setPlayer(audioPlayer).stopAudio();
//        AudioUtils.getAudioUtils()
//            .setPlayer(audioPlayer)
//            .playAudio(audioPath[(index % 2 == 0 ? 0 : 1)]);
//      }
//    }
//
//    if (index >= _max_page)
//      AudioUtils.getAudioUtils()
//          .setPlayer(audioPlayer)
//          .stopAudio(); //最后一页封面暂停音乐
    if (i == 1) {
      return imageList[indexH * 2];
    } else {
      if (imageList.length <= (indexH * 2 + 1))
        return new AssetImage('images/blank.bmp');
//      else if (imageList.length == (index * 2))
//        return new AssetImage('images/blank.bmp');
      else
        return imageList[indexH * 2 + 1];
    }
  }

  bool anim_flag = false;
  var size;

  @override
  Widget build(BuildContext context) {
    onStart();
    size = MediaQuery
        .of(context)
        .size;
//    CommonUtils.setScreenOrientation(CommonUtils.oriLeftAndRight);


    try {
      if(_oriVer==null){//第一次进来
        _oriVer = CommonUtils.screenIsVertical(size);//赋值 与屏幕方向返回值一样
        setState(() {
          if (CommonUtils.screenIsVertical(size)) {
            _max_pageV = 21;
//            myProgressBar.setProgress(index + 1, _max_page);
          } else {
            _max_pageH = 11;
//            myProgressBar.setProgress(index + 1, _max_page);
          }
        });
      }else if(_oriVer!=CommonUtils.screenIsVertical(size)){//如果保存的方向与获取的方向不一致，说明屏幕方向有变动
        _oriVer = !_oriVer;
        setState(() {
          if (CommonUtils.screenIsVertical(size)) {
            _max_pageV = 21;
            CommonUtils.screenIsVertical(size)==false?
            myProgressBarV.setProgress(indexH + 1, 11):
            myProgressBarH.setProgress(indexV + 1, 21);
          } else {
            _max_pageH = 11;
            CommonUtils.screenIsVertical(size)==false?
            myProgressBarV.setProgress(indexH + 1, 11):
            myProgressBarH.setProgress(indexV + 1, 21);
          }
        });
      }
//      if ((_oriVer == CommonUtils.screenIsVertical(size))) {
//        _oriVer = !_oriVer;
//        setState(() {
//          if (CommonUtils.screenIsVertical(size)) {
//            _max_page = 21;
//            myProgressBar.setProgress(index + 1, _max_page);
//          } else {
//            _max_page = 11;
//            myProgressBar.setProgress(index + 1, _max_page);
//          }
//        });
//      }
    } catch (Exception) {

    }

    if (CommonUtils.screenIsVertical(size)) {
      ScreenUtil.instance = new ScreenUtil(width: 1536, height: 2048)
        ..init(context);
    }
    else {
      ScreenUtil.instance = new ScreenUtil(width: 2048, height: 1536)
        ..init(context);
    }
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
            backgroundColor: CommonUtils.screenIsVertical(size) == false
                ? Colors.white
                : Colors.blue,
            title: new Text(
                '我的妈妈',
                style: TextStyle(fontSize: 28.0,
                    color: CommonUtils.screenIsVertical(size) == false ? Colors
                        .blue : Colors.white),
                ),
            leading: new GestureDetector(
                onTap: () {
                  onEvent('back_in_paly_page');
                  Navigator.pop(context, CommonUtils.oriUp);
                },
//          child: new ImageIcon(AssetImage('images/back_pink.png')),
                child: new Container(
                    child: Image.asset(
                        CommonUtils.screenIsVertical(size) == false
                            ? 'images/back_pink.png'
                            : 'images/back_white.png',
                        width: 38.0,
                        height: 38.0,
                        ),
                    )),
            centerTitle: true,
            ),
        body: new GestureDetector(
            onHorizontalDragStart: (d) {
              _startPosition = d.globalPosition.dx;
            },
            onHorizontalDragUpdate: (d) {
              _movePosition = d.globalPosition.dx;
            },
            onHorizontalDragDown: (d) {},
            onHorizontalDragEnd: (drag) {
              if (_startPosition - _movePosition > 30) {
                _ticker.stop();
                setState(() {
                  if(CommonUtils.screenIsVertical(size)){
                    indexV++;
//                    int ind = (indexV/2) as int;
                    indexH = CommonUtils.getIndex(indexV);
                  }else{
                    indexH++;
                    if(indexH==0)indexV = 0;
                    else{
                      indexV = indexH*2 ;
                    }
                  }
//                  indexV++;
//                  indexH++;
                  if (indexV >= _max_pageV) indexV = _max_pageV - 1;
                  if (indexH >= _max_pageH) indexH = _max_pageH - 1;
                  CommonUtils.screenIsVertical(size)==false?
                  myProgressBarV.setProgress(indexH + 1, 11):
                  myProgressBarH.setProgress(indexV + 1, 21);
                });
              } else if (_movePosition - _startPosition > 30) {
                _ticker.stop();
                setState(() {
                  if(CommonUtils.screenIsVertical(size)){
                    indexV--;
                  }else{
                    indexH--;
                  }
//                  indexV--;
//                  indexH--;
                  if (indexV < 0) indexV = 0;
                  if (indexH < 0) indexH = 0;
                  CommonUtils.screenIsVertical(size)==false?
                  myProgressBarV.setProgress(indexH + 1, 11):
                  myProgressBarH.setProgress(indexV + 1, 21);
                });
              }
            },
            onTap: () {
              print('点击了画面');
              if ((controller.isCompleted ||
                  controller.isDismissed)) { //动画未播放结束 则不进行任何逻辑改变
                if (anim_flag) //true 则播放淡出动画
                    {
                  print('则播放淡出动画');
                  controller.reverse();
                } else {
                  // 播放淡入动画
                  setState(() {
                    _flag_hide = !_flag_hide;
                  });
//            if (!_flag_hide) fadeTicker.start();
                  print('播放淡入动画');
                  controller.forward();
                }
                anim_flag = !anim_flag;
              } else
                print('动画未播放结束，你点太快啦!');
            },
            child: new Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(
                    bottom: 1.0, top: 1.0, left: 1.0, right: 1.0),
                decoration: CommonUtils.screenIsVertical(size) == false
                    ? new BoxDecoration(
                    image: new DecorationImage(
                        image: AssetImage('images/play_page_bg.png'),
                        fit: BoxFit.fill))
                    : null,
                child: new Stack(
                    children: <Widget>[
//                new Container(
//                  width: double.infinity,
//                  height: double.infinity,
//                  child: new PageView.builder(itemBuilder: null),
//                ),

                      CommonUtils.screenIsVertical(size) == true ?
                      new Container(
                          height: double.infinity,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0, top: 30.0),
                          decoration: new BoxDecoration(color: Colors.white
//                  image:
//                      new DecorationImage(image: setImage(), fit: BoxFit.fill)
                          ),
                          child: new Container(
                              child: new Column(
                                  children: <Widget>[
                                    new Container(
                                        height: ScreenUtil().setHeight(1335),
                                        width: ScreenUtil().setWidth(1234),
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: setImageVer(),
                                                fit: BoxFit.fill)),
                                        ),
                                    new Container(
                                        width: ScreenUtil().setWidth(697),
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: new Text(
                                            stringList[indexV],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                ),
                                            ),
                                        )
                                  ],
                                  ),
                              ),
                          )
                          : new Container(
                          margin: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 40.0, top: 1.0),
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    margin: EdgeInsets.only(top: 31.0,
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 5.0),
                                    alignment: FractionalOffset.topCenter,
                                    height: ScreenUtil().setHeight(1323),
                                    width: ScreenUtil().setWidth(932),
                                    child: new Column(
                                        children: <Widget>[
                                          new Container(
                                              height: ScreenUtil().setHeight(
                                                  1008),
                                              width: ScreenUtil().setWidth(932),
                                              decoration: new BoxDecoration(
                                                  image: new DecorationImage(
                                                      image: setImage(1),
                                                      fit: BoxFit.fill)),
                                              ),
                                          new Container(
                                              width: ScreenUtil().setWidth(558),
                                              margin: EdgeInsets.only(
                                                  top: 10.0),
                                              child: new Text(
                                                  stringList[indexH * 2],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      ),
                                                  ),
                                              )
                                        ],
                                        ),
                                    ),
                                new Container(
                                    margin: EdgeInsets.only(top: 31.0,
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 5.0),
                                    alignment: FractionalOffset.topCenter,
                                    height: ScreenUtil().setHeight(1323),
                                    width: ScreenUtil().setWidth(932),
                                    child: new Column(
                                        children: <Widget>[
                                          new Container(
                                              height: ScreenUtil().setHeight(
                                                  1008),
                                              width: ScreenUtil().setWidth(932),
                                              decoration: new BoxDecoration(
                                                  image: new DecorationImage(
                                                      image: setImage(2),
                                                      fit: BoxFit.fill)),
                                              ),
                                          new Container(
                                              width: ScreenUtil().setWidth(558),
                                              margin: EdgeInsets.only(
                                                  top: 10.0),
                                              child: new Text(
                                                  stringList[(indexH * 2) + 1],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      ),
                                                  ),
                                              )
                                        ],
                                        ),
                                    ),
                              ],
                              ),
                          ),

                      new Container(
                          child: new Offstage(
                              offstage: _flag_hide,
//              offstage: false,
                              child: new FadeTransition(
                                  opacity: curvedAnimation,
                                  child: control,
                                  ),
                              ),
                          ),
                      new Container(
                          child: new Offstage(
                              offstage: _flag_hide,
                              child: new FadeTransition(
                                  opacity: curvedAnimation,
                                  child: CommonUtils.screenIsVertical(size)==false?myProgressBarV:myProgressBarH,
                                  ),
                              ),
                          )
                    ],
                    )),
            ),
        );
  }

  onTaps() {
    print('点击了画面');
    setState(() {
      _flag_hide = !_flag_hide;
    });
  }
}

class PlayPageControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Control();
}

class _Control extends State<PlayPageControl> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        width: double.infinity,
        height: 75.0,
        child: new Container(
            padding: EdgeInsets.only(left: 25.0, top: 15.0),
            child: new Row(
                children: <Widget>[
//              new Align(
//                alignment: FractionalOffset.centerLeft,
//                child: new GestureDetector(
//                  onTap: () {
//                    Navigator.pop(context);
//                  },
//                  child: new Image.asset(
//                    'images/back_white.png',
//                    width: 25.0,
//                    height: 25.0,
//                  ),
//                ),
//              ),
                ],
                ),
            ));
  }
}
