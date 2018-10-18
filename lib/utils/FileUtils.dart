import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:books/play_page/MyProgressBar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//文件工具类
class FileUtils {
  //创建文件并返回文件对象
  //fileName 是你想要创建的文件的名称如  flutter/dart.text
  static Future<File> getLocalFile(String fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    if (!await file.exists()) file.create(recursive: true);
    return file;
  }

  //获取assets下的文件
  static Future<File> load(String fileName) async {
    File file = new File('${(await getTemporaryDirectory()).path}/booksVNNEXT/books/build/flutter_assets/assets/$fileName');
    return file;
  }

  //从fileNameFrom 写文件进入 fileNameTo
  static Future<Null> writeAudio2File(String fileNameFrom, String fileNameTo) async {
    String contents = (await load(fileNameFrom)).readAsBytes().toString();
    await (await getLocalFile(fileNameTo)).writeAsString(contents);
  }


  //获取文件的路径
  static Future<String> getFilePath(String fileName) async{
    return  (await getLocalFile(fileName)).path;
  }

}
