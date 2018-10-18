import 'package:flutter/widgets.dart';
import 'dart:async';
class SplashPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashPageState();
  }

}

class _SplashPageState extends State<SplashPage>{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Image.asset('images/splash.bmp');
  }
  void initStat(){
    super.initState();
    countDown();
  }

  void countDown() {

    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration,go2HomePage()); // ignore: use_of_void_result

  }

  go2HomePage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }




}