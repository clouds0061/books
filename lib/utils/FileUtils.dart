import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:books/utils/HttpUtils.dart';

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
    File file = new File('${(await getTemporaryDirectory())
        .path}/booksVNNEXT/books/build/flutter_assets/assets/$fileName');
    return file;
  }

  //从fileNameFrom 写文件进入 fileNameTo
  static Future<Null> writeAudio2File(String fileNameFrom,
      String fileNameTo) async {
    String contents = (await load(fileNameFrom)).readAsBytes().toString();
    await (await getLocalFile(fileNameTo)).writeAsString(contents);
  }


  //获取文件的路径
  static Future<String> getFilePath(String fileName) async {
    return (await getLocalFile(fileName)).path;
  }


  static Future<String> saveFileByStream(String result) async {
//    Stream<List<int>> inputStream = new Stream.empty();
//    inputStream.join(result);

    File file = new File('${(await getTemporaryDirectory())
        .path}/image_test.png');
    String path = file.path;
    print('------$path------');
    file.writeAsString(result.toString());
//    file.writeAs
  }

  //判断是否简历 文件夹
  static Future<int> chargeBook(String name) async {
//      Directory directory = new Directory('${await (getTemporaryDirectory())}/name}');
    Directory directory = new Directory(
        '${(await getTemporaryDirectory()) //新建 图书目录
            .path}/name}');
    if ( await directory.exists())
      return 2;
    else
      return 0;
  }

}
