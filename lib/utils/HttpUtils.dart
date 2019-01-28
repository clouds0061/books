import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HttpUtils {


  //post请求
  static void httpPost(String url, Map<String, String> params,
      Function callBack, Function errCallBack) async {
    try {
      http.Response response = await http.post(url, body: params);

      if (response.statusCode == 200) {
        if (callBack != null) {
          callBack(response.body);
        }
      } else {
        if (errCallBack != null) {
          errCallBack('请求失败，请检查网络连接！');
        }
      }
    } catch (e) {
      if (errCallBack != null) {
        errCallBack(e);
      }
    }
  }


  //get 请求
  static void httpGet(String url, Map<String, String> params, Function callBack,
      Function errCallBack) async{
    if (params != null && params.isNotEmpty) {
      StringBuffer buffer = new StringBuffer('?');
      params.forEach((key, value) {
        buffer.write('$key=$value&');
      });
      String paramStr = buffer.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }

    try{
      http.Response response = await http.get(url);
//      print(response.bodyBytes.toString());
      if(response.statusCode == 200){
        if(callBack!=null) callBack(response.body);
      }
    }catch (e){
      if(errCallBack!=null) errCallBack(e);
    }
  }



  static void saveImage() async {
    Dio dio = new Dio();
    File file = new File('${(await getTemporaryDirectory())
        .path}/');
    String path = file.path;
    String progress;
    await dio.download(
        "https://wxapp.ztsafe.com/keyValue/static/image/",
        file.path, onProgress: (progress, max) {

    }).then((Response) {
      print('-----下载完成-----');
      print('-----$path-----');
    });
  }
}