# flutter_tai

腾讯云智聆口语评测（Smart Oral Evaluation，SOE）是腾讯云推出的语音评测产品，是基于口语类教育培训场景和腾讯云的语音处理技术，应用特征提取、声学模型和语音识别算法，为儿童和成人提供高准确度的口语发音评测。支持单词、句子和段落模式的评测，多维度反馈口语表现，可广泛应用于中文及英语口语类教学中。

#暂时只有android功能，ios不知道怎么导入framework，知道的朋友麻烦留言告诉下我

## Getting Started


```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_tai/flutter_tai.dart';

import 'PermissionUtil.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterTai _tai = FlutterTai();
  int _volume = 0;
  bool _recoding = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _tai.responseFromProgress.listen((data) {
      _volume = data.volume;
      _progress = _volume / 120;
      setState(() {});
      print("音量：${data.volume} $_progress}");
    });
    _tai.responseFromStop.listen((data) {
      setState(() {
        _recoding = false;
      });
      print("stop：${data.err}");
    });
    _tai.responseFromResult.listen((data) {
      print("result：${data.err}");
    });
    _tai.responseFromEvaluationData.listen((data) {
      print(
          "EvaluationData：err:${data.err} ret:${data.ret} end:${data.end} seqId:${data.seqId} ");
    });
  }
 
  Future<void> record() async {
    _recoding = true;
    setState(() {});
//   Android SDK 参考https://cloud.tencent.com/document/product/884/31870
    try {
      await _tai.record("appId", "secretId",
          "secretKey", "how are you");
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LinearProgressIndicator(
              value: _progress,
            ),
            RaisedButton(
              child: Text(_recoding ? "停止录音" : "开始录音"),
              onPressed: record,
              color: Theme.of(context).primaryColor,
            ),
          ],
        )),
      ),
    );
  }
}

```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
