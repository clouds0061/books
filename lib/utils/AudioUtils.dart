import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:books/play_page/MyProgressBar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:books/utils/FileUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//语音播放工具类
class AudioUtils {
  static AudioUtils audioUtils;
  AudioPlayer audioPlayer;

  static AudioUtils getAudioUtils() {
    if (audioUtils == null) {
      audioUtils = new AudioUtils();
    }
    return audioUtils;
  }

  AudioUtils setPlayer(AudioPlayer audioPlayer){
    this.audioPlayer = audioPlayer;
    return audioUtils;
  }


  playAudio(String localPath) async {
    //开始播放 传入本地音乐地址
//    await audioCache.play(localPath);
//  await audioPlayer.play((await getLocalFile('audio.mp3')).path,isLocal: true);
//    await audioPlayer.play(
//        ((await FileUtils.getLocalFile('flutter_mp3/flutter_audio.mp3')).path),
//        isLocal: true);
    await audioPlayer.play(
        ((await FileUtils.load(localPath)).path),
        isLocal: true);
    return true;
  }

  void pauseAudio() async {
    //暂定播放
//    int result = await audioCache.pause();
    await audioPlayer.pause();
  }

  void stopAudio() async {
    //停止播放
//    int result = await audioCache.stop();
    await audioPlayer.stop();
  }

  void resumeAudio() async {
    //恢复播放
//    int result = await audioCache.resume();
    await audioPlayer.resume();
  }
}
