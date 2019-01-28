import 'dart:io';
import 'package:books/play_page/PlayPageNew.dart';
import 'package:books/utils/CommonUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:umeng/umeng.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageNew();
  }

}


class _HomePageNew extends State<HomePageNew> with TickerProviderStateMixin {
  final DeviceInfoPlugin infoPlugin = new DeviceInfoPlugin();
  String name = '';
  num ori = CommonUtils.oriUpAndDown; //屏幕方向 上下
  List<book> books = new List();
  List<bookList> bookLists = new List();
  List<String> words = new List();
  bool initBooks = false;
  SharedPreferences preferences;
  SwiperController swiperController = new SwiperController();
  ScrollController scrollController = new ScrollController();
  PageController headController = new PageController();
  Ticker autoPlayTicker; //自动淡出计时器
  int flag = 0;
  int book_num = 1;
  bool isWeChatIn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onStart();
    print('******step******: 1');
    CommonUtils.initStringDaddy(words);
//    initAnim();
    initDeviceName();
    getBooks();
    isWeChatInstalled();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    onEnd(); //页面结束
  }

  Future getBooks() async {
    print('******step******: 3');
    Dio dio = new Dio();
    bookLists.clear();
    bookLists.add(new bookList('我的爸爸', 'father',
        'https://wxapp.ztsafe.com/keyValue/static/image/father.png',
        2)); //默认的第一本数本地预存的
    bookLists.add(new bookList('我的妈妈', 'mother',
        'https://wxapp.ztsafe.com/keyValue/static/image/mother.png',
        2));
    dio.get(CommonUtils.book_list_url).then((response) {
      print('---bookResponse---: $response');
      var data = response.data;
      List list = data['data'];
      print('----list.length-----${list.length}');
      for (int k = 0; k < list.length; k++) {
        int bookExits = 0;
        String bookName = list[k]['bookName'];
        String coverImg = list[k]['coverImg'];
        String title = list[k]['titel'];
        CommonUtils.queryDownFlag(bookName).then((data) {
          bookExits = data;
          print('----data----$data');
          if (k != 0) bookLists.add(new bookList(title, bookName,
              '${CommonUtils.basic_img_url}/$bookName/$coverImg',
              bookExits));
          if (k == list.length - 1) {
            initBooks = true;
            setState(() {
              print('----setState----');
            });
          }
        });
      }
    });
  }

  AnimationController controller;
  CurvedAnimation curvedAnimation;

  void initAnim() async {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    curvedAnimation =
    new CurvedAnimation(curve: Curves.easeInOut, parent: controller);
    curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
//    controller.forward();
  }


  //获取设备信息
  Future<String> initDeviceName() async {
    print('******step******: 2');
    try {
      name = (await infoPlugin.iosInfo).model;
    } catch (Exception) {
      name = 'Failed to get device name';
    } finally {
      setState(() {
        if (CommonUtils.isIPad(name)) {
          initUmeng(1);
        } else {
          initUmeng(2);
        }
      });
    }
    return name;
  }

  void initUmeng(int i) async {
    //   String res = await Umeng.initUm('5bc44da0f1f556a593000135');//android
//      res = await Umeng.initUmIos("5bc569f3f1f556e25a000245", "");//ipad
//    String res = await Umeng.initUmIos("5bc3ef79f1f55675130000af", "");//iPhone
    if (i == 1) {
      String res = await Umeng.initUmIos("5bc569f3f1f556e25a000245", ""); //ipad
      print('iPad:$res');
    } else {
      String res = await Umeng.initUmIos(
          "5bc3ef79f1f55675130000af", ""); //iPhone
      print('iPhone:$res');
    }

    String _string;
    try {
      //第一个参数是wxAppId 第二个参数是微博的AppId
      _string = await Umeng.initWXShare("wx6d3f3256579a5f87", "3470678730");
    } on Exception {
      _string = 'wxShare failed!';
    }
  }

  Future<String> isWeChatInstalled() async {
    String res = await Umeng.isWeChatInstalled();
    print('微信是否下载：1为已下载，0为未下载   reslut= $res');
    if (res.contains('1'))
      isWeChatIn = true;
    else
      isWeChatIn = false;
    setState(() {});
  }

  void onEvent(String eventId) async {
    String res = await Umeng.onEvent(eventId);
  }

  void onStart() async {
    String res = await Umeng.onPageStart('首页');
  }

  void onEnd() async {
    String res = await Umeng.onPageEnd('首页');
  }


  @override
  Widget build(BuildContext context) {
    print('******step******: 4');
    ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
      ..init(context); //首先默认是手机端。
    try {
      CommonUtils.setScreenOrientation(ori);
    } catch (Exception) {
      print('出错啦：$Exception');
    }
    // TODO: implement build
    if (initBooks) {
      print('******step******: 6');
      initTicker();
      if (autoPlayTicker.isTicking) {
        autoPlayTicker.stop();
        autoPlayTicker.start();
      } else
        autoPlayTicker.start();
      return layout(context);
    }
    else {
      print('******step******: 5');
      return Scaffold(
          appBar: new AppBar(
              centerTitle: true,
              title: new Text('绘本图书'),
              ),
          body: Container(
              child: Center(
                  child: Container(
                      width: 25.0,
                      height: 25.0,
                      child: CircularProgressIndicator(),
                      ),
                  ),
              ),
          );
    }
  }

//  Widget gridView;

  Widget layout(BuildContext context) {
    print('******step******: 7');
    print('******isWeChatIn******: $isWeChatIn');

    return new MaterialApp(
        title: '',
        home: new Scaffold(
            appBar: new AppBar(
                centerTitle: true,
                title: new Text('绘本图书'),
                ),
            body: new Container(
                width: double.infinity,
                height: double.infinity,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('images/bg.png'),
                        fit: BoxFit.fill)),
                child: new Column(children: <Widget>[
                  new Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(640),
                      child: new Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            buildHead(context),
                            Align(
                                alignment: Alignment.topRight,
                                child: Offstage(
                                    offstage: !isWeChatIn,
                                    child: GestureDetector(
                                        onTap: () {
                                          share();
                                          onEvent('20181015001');
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 15.0, right: 14.0),
                                            width: 45.0,
                                            height: 45.0,
                                            child: Image.asset(
                                                'images/share.png'),
                                            ),
                                        ),
                                    ),
                                ),
                          ],
                          ),
                      ),
                  new Container(
                      width: double.infinity,
                      height: 30.0,
                      child: new Row(
                          children: <Widget>[
                            new Container(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text('我的书架'),
                                ),
                            new Expanded(
                                child: new Text(''),
                                ),
                            new Container(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Text(''),
                                ),
                          ],
                          ),
                      ),
                  new Expanded(
                      child: buildGird(context),
                      )
                ],),
                ),
            ),
        );
  }


  Widget buildHead(BuildContext context) {
    int itemCounts = 0; //下载完成了的图书才在上面的轮播页有展示
    List<bookList> list = new List(); //将下载好了的图书 放入新的列表提供给轮播页
    for (int k = 0; k < bookLists.length; k++) {
      if (bookLists[k].flag == 2) {
        itemCounts++;
        list.add(bookLists[k]);
      }
    }
    book_num = list.length;
    return new Container(
        child: PageView.builder(
            itemCount: itemCounts,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(1200),
                  child: GestureDetector(
                      onTap: () { //处理 点击时间 跳转到相应的播放画面
                        if (index == 0 || index == 1) { //第一本书已经下载好了 直接进入播放页面
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => PlayPageNew(null,index)
                          ));
                        } else { //下载完成了的书 点击进入播放页面
                          String bookName = bookLists[index].bookName;
                          String title = bookLists[index].title;
                          CommonUtils.queryNumOfPage(bookName).then((page) {
                            books.clear();
//                      book(this.title, this.name, this.pages, this.imgUrl, this.listWords,
//                          this.flag); //是否下载过 0:未下载 1：下载中  2：下载完成
                            books.add(new book(
                                title, bookName, page, '', null, 2));
                            onEvent('play'); //点击了paly按钮 进入播放页面
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => PlayPageNew(books[0],index)
                            ));
                          });
                        }
                      },
                      child: new Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: new FadeInImage.assetNetwork(
                              fit: BoxFit.fill,
                              placeholder: 'images/mom.png',
                              image: list[index].bookImageUrl,
                              )
                      ),),
                  );
            },
            scrollDirection: Axis.horizontal,
            controller: headController,
            ),
        );
  }

  //网格布局 书本部分
  Widget buildGird(BuildContext context) {
    print('******step******: 8');
    int itemCount = bookLists.length;
    print('----itemCount----$itemCount');
    try {
      return new Container(
          width: double.infinity,
          child: Container(
              width: double.infinity,
              child: Center(
                  child:
                  GridView.count(
                      children: children(context),
                      controller: scrollController,
                      crossAxisCount: 3,
                      mainAxisSpacing: 12.0,
                      scrollDirection: Axis.vertical,
                      ),
                  ),
              ),
          );
    } catch (e) {
      print('******error******: $e');
    }
  }

  List<Widget> children(BuildContext context) {
    List<Widget> list = new List();
    int num = bookLists.length;
    for (int i = 0; i < num; i++) {
      list.add(gridItem(context, i));
    }
    return list;
  }

  //网格 item
  Widget gridItem(BuildContext context, int index) {
    print('******step******: 9');
    int _flag = bookLists[index].flag;
    String imgUrl = bookLists[index].bookImageUrl;
    String bookName = bookLists[index].bookName;
    String title = bookLists[index].title;
    print('----imgUrl----$imgUrl');
    return new Container(
        child: new Center(
            child: new GestureDetector(
                onTap: () {
                  initAnim();
                  if (index == 0|| index == 1) { //第一本书已经下载好了 直接进入播放页面
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => PlayPageNew(null,index)
                    ));
                  } else {
                    if (_flag == 0) { //未下载的书
                      controller.forward();
                      saveImage(index, (progress, max) {
                        print('下载进度:$progress/$max');
                        if (progress == max) {
                          controller.stop();
                          bookLists[index].flag = 2;
                          setState(() {});
                        }
                      });
                      setState(() {
                        bookLists[index].flag = 1;
                      });
                    }
//                    else if(_flag == 1){
//                      controller.forward();
//                    }
                    else if (_flag == 2) { //下载完成了的书 点击进入播放页面
                      CommonUtils.queryNumOfPage(bookName).then((page) {
                        books.clear();
//                      book(this.title, this.name, this.pages, this.imgUrl, this.listWords,
//                          this.flag); //是否下载过 0:未下载 1：下载中  2：下载完成
                        books.add(new book(
                            title, bookName, page, '', null, 2));
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => PlayPageNew(books[0],index)
                        ));
                        onEvent('play'); //点击了paly按钮 进入播放页面
                      });
                    }
                  }
                },
                child: Container(
                    width: ScreenUtil().setWidth(220),
                    height: ScreenUtil().setHeight(400),
                    child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                              width: ScreenUtil().setWidth(220),
                              height: ScreenUtil().setHeight(400),
                              child: FadeInImage.assetNetwork(
                                  fit: BoxFit.fill,
                                  placeholder: 'images/mom.png',
                                  image: imgUrl
//                          new NetworkImage(
//                              bookLists[index].bookImageUrl, //图书封面
//                              fit: BoxFit.fill,),
                              ),
                              ),
                          Container(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      child: getLayout(index),
                                      ),
                                  ),
                              ),
                        ],
                        ),
                    )
            ),
            ),
        );
  }


  //网格item 中的图标 播放，下载
  Widget getLayout(int index) {
    print('******step******: 10');
    int _flag = bookLists[index].flag;
    if (index == 0) return Container();
    try {
      if (_flag == 0) { //未下载 现实下载按钮
        return Image.asset('images/play.png');
      } else if (_flag == 1) { //正在下载
        return new Container(
            child: RotationTransition(turns: curvedAnimation,
                child: Image.asset('images/waiting.png'),)
        );
      } else { //下载完成 现实空布局
        return new Container();
      }
    } catch (e) {
      return Image.asset('images/play.png');
    }
  }

  //保存 图书
  void saveImage(int index, Function f) async {
    Dio dio = new Dio();
    Response response = await dio.get(CommonUtils.book_details_url,
        data: {'bookName':bookLists[index].bookName});
    print('---response--- $response');
    var body = response.data;
    var data = body['data'];
    int numOfPage = data['numOfPage'];
    List words = data['wordsList'];
    String name = bookLists[index].bookName;

    print('---name--- $name');
    Directory d = new Directory('${(await getTemporaryDirectory()) //新建 图书目录
        .path}/$name');
    d.create();
    print('----directory----${d.path}');
    try {
      int page = 0;
      File file = new File('${(await getTemporaryDirectory())
          .path}/$name/words.txt');
      file.create();
      String word = '';
      for (int k = 0; k < words.length; k++) {
        var data = words[k];
//        String add = data['word'];
        word = word + data['word'] + '\n';
      }
      file.writeAsString(word);

//      File file2 = new File('${(await getTemporaryDirectory())
//          .path}/${bookLists[index].bookName}/bookInfo.txt');
//      file2.create();
//      file2.writeAsString('$numOfPage');
      print('${CommonUtils.basic_img_url}/$name/image1.jpg');
      for (int i = 0; i < numOfPage; i++) { //一张一张的下载
        File file = new File('${(await getTemporaryDirectory())
            .path}/$name/image${i + 1}.jpg');
        dio.download(
            '${CommonUtils.basic_img_url}/$name/image${i +
                1}.jpg',
            file.path).then((data) {
          f(page + 1, numOfPage); //传递下载进度
          page++;
        });
      }
      CommonUtils.addInfo(name, numOfPage, 2);
    } catch (e) {
      print('-----error-----: $e');
    }
  }

  void initTicker() {
    print('/----num2-----/$num');
    if (autoPlayTicker == null) {
      autoPlayTicker = new Ticker((Duration d) {
        //3秒后 跳转到下一页
        if (d.inSeconds % 3 == 0 && d.inSeconds >= 3) {
          autoPlayTicker.stop(canceled: true);
          print('/----i-----/$flag');
          print('/----book_num-----/$book_num');
          if (flag >= book_num) flag = 0;
//          headController.jumpToPage(i);
          headController.animateToPage(
              flag, duration: new Duration(milliseconds: 500),
              curve: Curves.easeInOut);
          flag++;
//          autoPlayTicker.stop();
          autoPlayTicker.start();
        }
      });
    }
  }

  //微信分享
  void share() {
    String imgUrl;
    String shareUrl;
    Dio dio = new Dio();
    //{"errno":0,"errmsg":"","data":{"key":"mother_shareUrl","value":[{"imgUrl":"https://wxapp.ztsafe.com/keyValue/static/image/mother_mini.png","shareUrl":"https://www.baidu.com"}]}}
    dio.get(
        'https://wxapp.ztsafe.com/keyValue/keyValue/getValue?key=mother_shareUrl')
        .then((response) {
      print('|||-----share_response----$response');
      if (response != null) {
        var body = response.data;
        print('|||-----share_body----$body');
        var data = body['data'];
        print('|||-----share_data----$data');
        var value = data['value'];
        print('|||-----share_value----$value');
        value.forEach((item) {
          imgUrl = item['imgUrl'];
          shareUrl = item['shareUrl'];
        });
      }
      if (imgUrl != null && shareUrl != null) {
//        Umeng.wXShareWeb(imgUrl, shareUrl, '绘图故事之我妈妈');
        Umeng.wXShareWebDescr(imgUrl,shareUrl,'绘图故事之我爸爸','我爱我爸爸');
      }
    });
  }

}

//书本详情
class book {
  String title; //页面标题  如 我的爷爷
  String name; //书本名 如 mother
  int pages; //页数  如 21
  String imgUrl; //封面img url
  List<String> listWords; //每页书本文字
  int flag;

  book(this.title, this.name, this.pages, this.imgUrl, this.listWords,
      this.flag); //是否下载过 0:未下载 1：下载中  2：下载完成


}

//列表书本信息
class bookList {

  String title;
  String bookName; //书本名  如：mother
  String bookImageUrl; //书本封面url 如：https://www.baidu.2222.jpg;
  int flag;

  bookList(this.title, this.bookName, this.bookImageUrl, this.flag); //判断是否
//
}
