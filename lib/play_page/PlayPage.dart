//import 'dart:async';
//
//import 'package:flutter/widgets.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
//import 'package:books/play_page/MyProgressBar.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:audioplayers/audio_cache.dart';
//import 'package:books/utils/FileUtils.dart';
//import 'package:books/utils/AudioUtils.dart';
//import 'package:books/widget/LoadingWidget.dart';
//import 'package:path_provider/path_provider.dart';
//import 'dart:io';
//
////播放页面  //不用了的
//class PlayPage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return new _PlayPage();
//  }
//}
//
//class _PlayPage extends State<PlayPage> {
//  String localPath = 'audio2.mp3';
//  Timer timer;
//  MyProgressBar progressBar;
//  final AudioPlayer audioPlayer = new AudioPlayer();
//  AudioCache audioCache = new AudioCache();
//
//  bool _flag = true; //true不显示换页按钮  false反之
//  var index = 0; //播放的页数
//  List<ImageProvider> imageList = new List(); //放需要播放的图片
//  List<num> perPageTimes = new List(); //每页观看时间
//  List<String> audioPath = new List();
//  Ticker _ticker; //计时器 用来几时
//
//  var _max_page = 30; //最大页数 因为是从0开始的 所以31也的漫画在这里最大页数是30
//
//  _PlayPage() {
//    _ticker = new Ticker((Duration d) {
//      //建立计时器。没*秒让index++;
//      //5秒一次切换
//      if (d.inSeconds % 4 == 0 && d.inSeconds >= 4) {
//        _ticker.stop(canceled: true);
//        setState(() {
//          index++;
//          progressBar.setProgress(index + 1);
//        });
//      }
//    });
//
////    timer = new Timer(Duration(milliseconds: 1000), _loadAudio);
////    _ticker.start();
////    AudioUtils.getAudioUtils(audioPlayer).playAudio('');
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    audioCache.load('');
//    initImage();
//    initTimes();
//    audioPath.add('audio1.mp3');
//    audioPath.add('audio2.mp3');
//    progressBar = new MyProgressBar(31, index + 1,(){});
//    //开始播放音乐
//    print('initState');
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//    if (_ticker.isTicking) _ticker.stop(canceled: true);
//    AudioUtils.getAudioUtils().setPlayer(audioPlayer).stopAudio();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    //0 进入加载动画
//    return buildUI();
//  }
//
//  ImageProvider setImage() {
//    if (!_ticker.isTicking && _flag) if (index < _max_page)
//      _ticker.start(); //在没有计时器并且不是,还有不是最后一页手动换页的暂停状态下要开始新的计时
//    print('index增长到了$index');
//    if (index >= _max_page) {
//      index = _max_page;
//      _ticker.stop(canceled: true);
//    }
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
//    return imageList[index];
//  }
//
//  MaterialApp buildUI() {
//    return new MaterialApp(
//      title: '',
//      home: new Scaffold(
//          appBar: new AppBar(
//            title: new Row(
//              children: <Widget>[
//                new IconButton(
//                    icon: new Icon(Icons.arrow_back),
//                    padding: EdgeInsets.symmetric(horizontal: 5.0),
//                    onPressed: () {
//                      //点击appBar栏的返回键返回上一页，同时暂停还在运行的计时器
//                      if (_ticker.isTicking) _ticker.stop(canceled: true);
//                      Navigator.pop(context);
//                    }),
//              ],
//            ),
//          ),
//          body: new GestureDetector(
//            onTap: () {
//              //触摸播放中的图画 暂停播放
//              if (_ticker.isTicking) _ticker.stop(canceled: true);
//              setState(() {
//                _flag = false;
//                progressBar.setProgress(index + 1);
//                AudioUtils.getAudioUtils().setPlayer(audioPlayer).pauseAudio();
//              });
//            },
//            child: new Container(
//              //
//              height: double.infinity,
//              width: double.infinity,
//              padding: EdgeInsets.all(5.0),
//              decoration: new BoxDecoration(
//                  image:
//                      new DecorationImage(image: setImage(), fit: BoxFit.fill)),
//              //设置整个屏幕的背景为图书当前页面
//              child: new Column(
//                children: <Widget>[
//                  new Align(
//                    child: new Container(
//                      child: new Text(''),
//                    ),
//                    alignment: Alignment.center,
//                  ),
//                  new Align(
//                    //向前翻页
//                    alignment: FractionalOffset.center,
//                    child: new Container(
//                      padding: EdgeInsets.symmetric(vertical: 160.0),
//                      child: new Row(
//                        children: <Widget>[
//                          new Offstage(
//                            offstage: _flag,
//                            child: IconButton(
//                              icon: new Icon(Icons.arrow_back),
//                              onPressed: () {
//                                _ticker.stop(canceled: true);
//                                setState(() {
//                                  index--;
//                                  if (index < 0) index = 0;
//                                  progressBar.setProgress(index + 1);
//                                });
//                              },
//                            ),
//                          ),
//                          new Expanded(
//                            child: new Text(''),
//                          ),
//                          new Offstage(
//                              //向后翻页
//                              offstage: _flag,
//                              child: new Container(
//                                child: IconButton(
//                                  icon: new Icon(Icons.arrow_forward),
//                                  onPressed: () {
//                                    _ticker.stop(canceled: true);
//                                    setState(() {
//                                      index++;
//                                      if (index > _max_page) index = _max_page;
//                                      progressBar.setProgress(index + 1);
//                                    });
//                                  },
//                                ),
//                              )),
//                        ],
//                      ),
//                    ),
//                  ),
//                  new Expanded(
//                    child: new Row(
//                      children: <Widget>[
//                        new Align(
//                            alignment: FractionalOffset.bottomCenter,
//                            child: new Container(
//                              padding: EdgeInsets.only(left: 10.0),
//                              child: new Offstage(
//                                offstage: _flag,
//                                child: new IconButton(
//                                    icon:
//                                        new Icon(Icons.arrow_drop_down_circle),
//                                    onPressed: () {
//                                      _ticker.start();
//                                      setState(() {
//                                        _flag = true;
//                                        if (index < _max_page)
//                                          AudioUtils.getAudioUtils()
//                                              .setPlayer(audioPlayer)
//                                              .resumeAudio();
//                                      });
//                                    }),
//                              ),
//                            )),
//                        new Align(
//                          alignment: FractionalOffset.bottomCenter,
//                          child: new Container(
//                            margin: EdgeInsets.only(bottom: 5.0),
//                            child: progressBar,
//                          ),
//                        )
//                      ],
//                    ),
//                    //进度条
////                    child: new Container(
////                        child:
////                    )),
//                  ),
//                ],
//              ),
//            ),
//          )),
//    );
//  }
//
//  //初始化 存放需要展示的图片进入list
//  void initImage() {
//    imageList.add(new AssetImage('images/imageA1.jpg'));
//    imageList.add(new AssetImage('images/imageA2.jpg'));
//    for (int i = 0; i < _max_page - 2; i++) {
//      var num = i + 1;
//      imageList.add(new AssetImage('images/image$num.jpg'));
//    }
//    imageList.add(new AssetImage('images/imageA3.jpg'));
//  }
//
//  //初始化 每张图片需要展示的时间
//  void initTimes() {}
//}
