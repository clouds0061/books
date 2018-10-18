import 'package:flutter/widgets.dart';
import 'dart:math';

class Progress extends CustomPainter {
  Color _progress_frame_color; //进度条边框颜色
  Color _progress_bac_color; //进度条底层颜色
  Color _progress_color; //进度的颜色
  Color _progress_num_color; //显示进度字体的颜色
  num _progress; //进度
  num _max_num_progress; //数字最大进度  示例:(1/22)

  num _new_progress = -1; //新进度
  bool flag = false;
  double _pi = pi;

  Progress(
      this._progress_frame_color,
      this._progress_bac_color,
      this._progress_color,
      this._progress,
      this._max_num_progress,
      this._progress_num_color); //  _Progress(Color _progress_frame_color, num _progress, num _max_num_progress,
//      Color _progress_bac_color, Color _progress_color) {
//    this._progress_frame_color = _progress_frame_color; //进度条边框颜色
//    this._max_num_progress = _max_num_progress; //数字最大进度  示例:(1/22)
//    this._progress = _progress; //进度
//    this._progress_bac_color = _progress_bac_color; //进度条底层颜色
//    this._progress_color = _progress_color; //进度条底层颜色
//  }

  //设置新进度
  void new_progress(num value) {
    _new_progress = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    flag = false;
    drawProgress(canvas, size);
    drawCurrentProgress(canvas, size);
  }

  //进度与当前进度不一致时 重新绘制进度
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    if (_new_progress != -1) {
      if (_progress != _new_progress) {
        flag = true;
        _progress = _new_progress;
      }
    }
    return flag;
  }

  //画出进度条
  void drawProgress(Canvas canvas, Size size) {
    //画左边的半圆
    var _radius = size.height / 2; //左右半圆的半径为控件高度的一半
//    var _radius = 40.0; //左右半圆的半径为控件高度的一半
    var paint = new Paint();
    paint.color = _progress_bac_color;
    paint.style = PaintingStyle.fill;
    Rect rect = new Rect.fromLTWH(0.0, 0.0, _radius * 2, _radius * 2);
    canvas.drawArc(rect, pi / 2, pi, false, paint);

    //画中间的长方形
    Paint paint2 = new Paint();
    paint2.style = PaintingStyle.fill;
    paint2.color = _progress_bac_color;
    Rect rect2 =
        new Rect.fromLTWH(_radius, 0.0, size.width - _radius * 2, _radius * 2);
    canvas.drawRect(rect2, paint2);

    //画出数字进度

    //画右边的半圆
//    var _radiusR = 40.0; //左右半圆的半径为控件高度的一半
//    var paintR = new Paint();
    paint.color = _progress_bac_color;
    paint.style = PaintingStyle.fill;
    Rect rectR = new Rect.fromLTWH(
        size.width - _radius * 2, 0.0, _radius * 2, _radius * 2);
    canvas.drawArc(rectR, pi * 3 / 2, pi, false, paint);
  }

  //画出当前进度
  void drawCurrentProgress(Canvas canvas, Size size) {
    var _radius = size.height / 2; //左右半圆的半径为控件高度的一半
    var paint = new Paint();
    if (_progress > 0) {
      //画左边的半圆
//    var _radius = 40.0; //左右半圆的半径为控件高度的一半
      paint.color = _progress_color;
      paint.style = PaintingStyle.fill;
      Rect rect = new Rect.fromLTWH(0.0, 0.0, _radius * 2, _radius * 2);
      canvas.drawArc(rect, pi / 2, pi, false, paint);
    }

    num _current_width =
        (size.width - _radius * 2) * _progress / _max_num_progress;
    //画中间的长方形
    Paint paint2 = new Paint();
    paint2.style = PaintingStyle.fill;
    paint2.color = _progress_color;
    Rect rect2 = new Rect.fromLTWH(_radius, 0.0, _current_width, _radius * 2);
    canvas.drawRect(rect2, paint2);

    if (_progress == _max_num_progress) {
      //画右边的半圆
//    var _radiusR = 40.0; //左右半圆的半径为控件高度的一半
//    var paintR = new Paint();
      paint.color = _progress_color;
      paint.style = PaintingStyle.fill;
      Rect rectR = new Rect.fromLTWH(
          size.width - _radius * 2, 0.0, _radius * 2, _radius * 2);
      canvas.drawArc(rectR, pi * 3 / 2, pi, false, paint);
    }
  }
}
