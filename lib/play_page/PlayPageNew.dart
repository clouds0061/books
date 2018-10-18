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

class PlayPageNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Play();
}

class _Play extends State<PlayPageNew> with TickerProviderStateMixin {
  PlayPageControl control; //控制按钮
  MyProgressBar myProgressBar; //进度条
  bool _flag_hide = false; //是否显示播放控制组件 true是隐藏 false是显示

  Timer timer;
  List<ImageProvider> imageList = new List(); //放需要播放的图片
  List<String> stringList = new List(); //放需要暂时的文字
  num _startPosition = 0;
  num _movePosition = 0;
  var _max_page = 20; //最大页数 因为是从0开始的 所以31也的漫画在这里最大页数是30
  var index = 0; //播放的页数
  Ticker _ticker; //计时器 用来几时
  Ticker fadeTicker; //自动淡出计时器
  bool _flag = true; //是否暂停

  AnimationController controller; //动画控制器
  CurvedAnimation curvedAnimation; //动画

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    control = new PlayPageControl();
    myProgressBar = new MyProgressBar(21, index + 1, _setFlag);
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
    super.dispose();
    onEnd();
  }

  void onStart() async{
    String res = await Umeng.onPageStart('iPhone播放页面');
  }

  void onEnd() async{
    String res = await Umeng.onPageEnd('iPhone播放页面');
  }

  void onEvent() async{
    String res = await Umeng.onEvent('back_in_paly_page');
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
    for (int i = 0; i < _max_page + 1; i++) {
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
      if (d.inSeconds % 4 == 0 && d.inSeconds >= 4) {
        _ticker.stop(canceled: true);
        setState(() {
          index++;
          myProgressBar.setProgress(index + 1,_max_page+1);
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

  //设置播放图片
  ImageProvider setImage() {
    if (!_ticker.isTicking && _flag) if (index < _max_page)
      _ticker.start(); //在没有计时器并且不是,还有不是最后一页手动换页的暂停状态下要开始新的计时
//    print('index增长到了$index');
    if (index >= _max_page) {
      index = _max_page;
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
    return imageList[index];
  }

  bool anim_flag = false;

  @override
  Widget build(BuildContext context) {
    onStart();
    ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
      ..init(context); //首先默认是手机端。
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('我的妈妈'),
        leading: new GestureDetector(
          onTap: () {
            onEvent();
            Navigator.pop(context, CommonUtils.oriUpAndDown);
          },
          child: new ImageIcon(AssetImage('images/back_white.png')),
        ),
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
              index++;
              if (index > _max_page) index = _max_page;
              myProgressBar.setProgress(index + 1,_max_page+1);
            });
          } else if (_movePosition - _startPosition > 30) {
            _ticker.stop();
            setState(() {
              index--;
              if (index < 0) index = 0;
              myProgressBar.setProgress(index + 1,_max_page+1);
            });
          }
        },
        onTap: () {
          print('点击了画面');
          if ((controller.isCompleted || controller.isDismissed)) {
            //动画未播放结束 则不进行任何逻辑改变
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
            child: new Stack(
          children: <Widget>[
            new Container(
              width: double.infinity,
              height: double.infinity,
              decoration: new BoxDecoration(color: Colors.white
//                  image:
//                      new DecorationImage(image: setImage(), fit: BoxFit.fill)
                  ),
            ),
//                new Container(
//                  width: double.infinity,
//                  height: double.infinity,
//                  child: new PageView.builder(itemBuilder: null),
//                ),
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
                      height: ScreenUtil().setHeight(754),
                      width: ScreenUtil().setWidth(697),
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: setImage(), fit: BoxFit.fill)),
                    ),
                    new Container(
                      width: ScreenUtil().setWidth(497),
                      margin: EdgeInsets.only(top: 20.0),
                      child: new Text(
                        stringList[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ],
                ),
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
                  child: myProgressBar,
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
