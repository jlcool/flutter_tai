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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> record() async {
    _recoding = true;
    setState(() {});
    if (await PermissionUtil.checkStorage() &&
        await PermissionUtil.checkMicrophone(context)) {
    try {
      await _tai.record("", "",
          "", "how are you",);
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    }
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
