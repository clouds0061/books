import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:books/utils/CommonUtils.dart';
import 'package:books/utils/HttpUtils.dart';
import 'package:convert/convert.dart';

class BookListView extends StatefulWidget {
  String name;

  @override
  State<StatefulWidget> createState() {
    _BookList _bookList = new _BookList();
    _bookList.setName(name);
    // TODO: implement createState
    return _bookList;
  }

  BookListView(this.name);

}

class _BookList extends State<BookListView> {
  List<String> bookList = new List();
  List<Model> models = new List();
  List<ImageProvider> books = new List();

  String name;

  void setName(String name) {
    this.name = name;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageResources();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 3; i++) {
      bookList.add('第$i个图书！');
    }
    books.add(AssetImage('images/grandfather.png'));
    books.add(AssetImage('images/daddy1.png'));
    books.add(AssetImage('images/rabbit.png'));
    // TODO: implement build
    return new ListView.builder(
        itemCount: 3,
        itemBuilder: buildItem,
        scrollDirection: Axis.horizontal,
        );
  }


  //请求网络数据
  void getImageResources() {
//    Map<String,String> params = new Map();
    Map<String, String> params = new Map();
    params['key'] = 'more_books';
    HttpUtils.httpGet('https://wxapp.ztsafe.com/keyValue/keyValue/getValue', params, (data) {
      if (data != null) {
        final body = json.decode(data.toString());
        print('---body--- $body');
        final datas = body['data'];
        final value = datas['value'];
        List<Model> items = new List();
        value.forEach((item) {
          items.add(new Model(item['imgUrl'], item['appUrl']));
        });
        setState(() {
          if (items != null && items.length != 0) models.addAll(items);
        });
      }
    }, (error) {
      print(error);
    });
  }

  //ListView的Item
  Widget buildItem(BuildContext context, int index) {
    print('设备型号为:$name');
    String url;
    String imgUrl;
    if (models != null && models.isNotEmpty) url = models[index].appUrl;
    if (models != null && models.isNotEmpty) imgUrl = models[index].imgUrl;
    print('---url---- $url');
    print('---imgUrl---- $imgUrl');
    if (CommonUtils.isIPad(name)) {
      ScreenUtil.instance = new ScreenUtil(width: 1553, height: 2048)
        ..init(context); //首先默认是手机端。
    } else {
      ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)
        ..init(context); //首先默认是手机端。
    }
    return new GestureDetector(
        onTap: () async {
//        const url =
//            'http://m.appstore.nubia.com/detailedness.html?SoftId=59462&SoftItemId=3379314';
          print('点击了' + bookList[index]);
          if (url != null && url.isNotEmpty) {
            try {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '打开失败!';
              }
            } catch (e) {
              print(e);
            }
          }
        },
        child: new Align(
            alignment: FractionalOffset.bottomCenter,
            child: new Container(
//          height: 140.0,
//          width: 106.0,
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.only(left: CommonUtils.isIPad(name) == true
                    ? ScreenUtil().setWidth(40)
                    : ScreenUtil().setWidth(15)),
                child: new Container(
                    width: CommonUtils.isIPad(name) == true
                        ? ScreenUtil().setWidth(460)
                        : ScreenUtil().setWidth(220),
                    height: CommonUtils.isIPad(name) == true
                        ? ScreenUtil().setHeight(590)
                        : ScreenUtil().setHeight(280),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
//                image: new DecorationImage(image: new NetworkImage(imgUrl),fit: BoxFit.fill)
                        image: (imgUrl != null && imgUrl.isNotEmpty) == true
                            ? new DecorationImage(
                            image: new NetworkImage(imgUrl), fit: BoxFit.fill)
                            : new DecorationImage(
                            image: books[index], fit: BoxFit.fill),
                        ),
                    ),
                ),
            ),
        );
  }
}

class Model {
  String imgUrl;
  String appUrl;

  Model(this.imgUrl, this.appUrl);

}
