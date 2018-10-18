import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'dart:ui';

//通用工具类
class CommonUtils {
  static final num oriUpAndDown = 1; //竖屏
  static final num oriLeftAndRight = 2; //横屏
  static final num oriAll = 3; //横竖屏切换
  static final num oriUp = 4;//上竖屏
  static final num oriLeft = 5;//左横屏


  static int getIndex(int oldIndex){
    int ii = (oldIndex~/2);
    int new_index;
    switch(ii){
      case 0:new_index = 0;
        break;
      case 1:new_index = 1;
        break;
      case 2:new_index = 2;
      break;
      case 3:new_index = 3;
      break;
      case 4:new_index = 4;
      break;
      case 5:new_index = 5;
      break;
      case 6:new_index = 6;
        break;
      case 7:new_index = 7;
        break;
      case 8:new_index = 8;
        break;
      case 9:new_index = 9;
        break;
      case 10:new_index = 10;
        break;
      case 11:new_index = 11;
        break;
      case 12:new_index = 12;
        break;
    }
    return new_index;
  }

  ///判断是否是pad  传入mode
  static bool isIPad(var name) {
      if(name.toString().contains('Phone')) return false;
      else return true;

    return false;//测试 返回，需要测试就注释掉上面两行
  }


  //判断屏幕是否是竖屏；
  static bool screenIsVertical(Size size){
    var width = size.width;
    var height = size.height;
    if(width>height) return false;//宽度大于高度 是横屏
    else return true;//宽度小于高度 是竖屏
    return true;
  }


  ///设置屏幕方向 1为竖屏  2为横屏 必须在初始化界面前调用
  static void setScreenOrientation(num ori) {
    if (ori == oriUpAndDown) {
      //1 竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else if (ori == oriLeftAndRight) {
      //2 横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else if (ori == oriAll) {
      //3 横竖屏切换 这中的效果是 先横屏后竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }  else if (ori == oriUp) {
      //4
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }  else if (ori == oriLeft) {
      //5
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      // 其他 默认竖屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

//  ScreenUtil.instance = new ScreenUtil(width: 750, height: 1334)..init(context);
  static bool isPad() {
    bool flag;
//    // 屏幕宽度
//    num screenWidth = display.getWidth();
//    // 屏幕高度
//    num screenHeight = display.getHeight();
//    window.physicalSize.width
    ScreenUtil.pixelRatio;
    num width = window.physicalSize.width;
    num height = window.physicalSize.height;
    num devicePixelRatio = window.devicePixelRatio;
    double x = pow(width / window.devicePixelRatio, 2);
    double y = pow(height / window.devicePixelRatio, 2);
    // 屏幕尺寸
    double screenInches = sqrt(x + y);
    // 大于6尺寸则为Pad
//    if (height < 1024) {
//      flag = false;
//    } else if
//      (height > 1024 && height < 1280)
//    {
//      double minX = pow(width / window.devicePixelRatio, 2);
//      double minY = pow(height / window.devicePixelRatio, 2);
//      double maxX = pow(width / window.devicePixelRatio, 2);
//      double maxY = pow(height / window.devicePixelRatio, 2);
//      // 屏幕尺寸
//      double screenInches = sqrt(x + y);
//    }else if(){
//
//    }
    print('设备的宽度为:$width,\n'
        '设备的高度为:$height,\n'
        '设备的像素密度为:$devicePixelRatio,\n设备尺寸为:$screenInches');
//    if (screenInches >= 7.0) {
//      return flag;
//    }
    return flag;
  }


  static initString(List<String> list){
    list.add('这是我妈妈，她真的很棒!');
    list.add('我妈妈是个厨艺特好的大厨师!');
    list.add('也是一个很会杂耍的特技演员。');
    list.add('她不但是个神奇的画家。');
    list.add('还是全世界最强壮的女人!');
    list.add('我妈妈是一个有魔法的园丁，她能让所有的东西都长的很好。');
    list.add('她也是一个好心的仙子,我难过时，总是把我变得很开心。');
    list.add('她的歌声像天使一样甜美。');
    list.add('吼起来像狮子一样凶猛。');
    list.add('我妈妈真的，真的很棒!我妈妈像蝴蝶一样美丽，');
    list.add('还像沙发一样舒适。');
    list.add('她像猫咪一样温柔。');
    list.add('有时候又像犀牛一样强悍。');
    list.add('不管我妈妈是个舞蹈家，');
    list.add('还是个航天员，');
    list.add('也不管她是个电影明星。');
    list.add('还是个大老板，她都是我妈妈。');
    list.add('我妈妈是一个超人妈妈，');
    list.add('常常逗得我哈哈大笑。');
    list.add('我爱她，而且你知道吗？');
    list.add('她也爱我!(永远爱我。)');
    list.add('');
    list.add('');
    list.add('');
    list.add('');
    list.add('');
  }

}
