import 'package:flutter/material.dart';
import 'dart:async';

//loading 动画
class LoadingWidget extends StatefulWidget {
  final Future<Null> loadingCallBack;

  @override
  State<StatefulWidget> createState() => new _Loading();

  LoadingWidget(this.loadingCallBack);


}

class _Loading extends State<LoadingWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(new Duration(milliseconds: 10), () {
      //每隔10ms回调一次
      widget.loadingCallBack.then((Null) {
        //这里Null表示回调的时候不指定类型
        Navigator.of(context).pop(); //所以pop()里面不需要传参,这里关闭对话框并获取回调的值
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
        child: new CircularProgressIndicator(),
      );
  }

  _Loading();
}
