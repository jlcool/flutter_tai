import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_tai/response.dart';
import 'package:uuid/uuid.dart';

class FlutterTai {
  final MethodChannel _channel = MethodChannel('flutter_tai')
    ..setMethodCallHandler(_handler);
  static final _uuid = new Uuid();
  String id;
  static final alis = new Map<String, FlutterTai>();

  FlutterTai() {
    id = _uuid.v4();
    alis[id] = this;
  }

  StreamController<ProgressResponse> _responseProgressController =
      new StreamController.broadcast();

  Stream<ProgressResponse> get responseFromProgress =>
      _responseProgressController.stream;

  StreamController<ResultResponse> _responseResultController =
      new StreamController.broadcast();

  Stream<ResultResponse> get responseFromResult =>
      _responseResultController.stream;

  StreamController<StopResponse> _responseStopController =
      new StreamController.broadcast();

  Stream<StopResponse> get responseFromStop => _responseStopController.stream;

  StreamController<EvaluationDataResponse> _responseEvaluationDataController =
      new StreamController.broadcast();

  Stream<EvaluationDataResponse> get responseFromEvaluationData =>
      _responseEvaluationDataController.stream;

  Future<dynamic> _invokeMethod(String method,
      [Map<String, dynamic> arguments = const {}]) {
    Map<String, dynamic> withId = Map.of(arguments);
    withId['id'] = id;
    return _channel.invokeMethod(method, withId);
  }

  static Future<dynamic> _handler(MethodCall methodCall) {
    String id = (methodCall.arguments as Map)['id'];
    FlutterTai _tai = alis[id];

    switch (methodCall.method) {
      case "onProgress":
        ProgressResponse res = new ProgressResponse(
            volume: int.parse(methodCall.arguments["volume"].toString()));
        _tai._responseProgressController.add(res);
        break;
      case "onResult":
        ResultResponse res =
            new ResultResponse(err: methodCall.arguments["err"].toString());
        _tai._responseResultController.add(res);
        break;
      case "onEvaluationData":
        EvaluationDataResponse res = new EvaluationDataResponse(
          seqId: int.parse(methodCall.arguments["seqId"].toString()),
          end: int.parse(methodCall.arguments["end"].toString()),
          err: methodCall.arguments["err"].toString(),
          ret: methodCall.arguments["ret"].toString(),
        );
        _tai._responseEvaluationDataController.add(res);
        break;
      case "onStop":
        StopResponse res =
            new StopResponse(err: methodCall.arguments["err"].toString());
        _tai._responseStopController.add(res);
        break;
    }
  }
  Future stop()async{
    await _invokeMethod('stop');
  }
  Future record(String appId, String secretId, String secretKey, String refText,
      {String soeAppId = "",
      String token = "",
      int workMode = TAIOralEvaluationWorkMode.STREAM,
      int evalMode = TAIOralEvaluationEvalMode.FREE,
      int storageMode = TAIOralEvaluationStorageMode.ENABLE,
      int serverType = TAIOralEvaluationServerType.ENGLISH,
      int textMode = TAIOralEvaluationTextMode.NORMAL,
      double scoreCoeff = 1,
      int timeout = -1,
      int retryTimes = -1,
      double fragSize = 1,
      bool fragEnable = true,
      bool vadEnable = true,
      int vadInterval = 3000}) async {
    if (workMode == TAIOralEvaluationWorkMode.STREAM) {
      timeout = timeout == -1 ? 5 : timeout;
      retryTimes = retryTimes == -1 ? 5 : retryTimes;
    } else {
      timeout = timeout == -1 ? 5 : timeout;
      retryTimes = retryTimes == -1 ? 5 : retryTimes;
    }
    fragSize = fragSize * 1024;
    await _invokeMethod('record', {
      "appId": appId,
      "secretId": secretId,
      "secretKey": secretKey,
      "refText": refText,
      "soeAppId": soeAppId,
      "token": token,
      "workMode": workMode,
      "evalMode": evalMode,
      "storageMode": storageMode,
      "serverType": serverType,
      "serverType": serverType,
      "textMode": textMode,
      "scoreCoeff": scoreCoeff,
      "timeout": timeout,
      "retryTimes": retryTimes,
      "fragSize": fragSize.toInt(),
      "fragEnable": fragEnable,
      "vadEnable": vadEnable,
      "vadInterval": vadInterval
    });
  }
}

class TAIOralEvaluationWorkMode {
  /**
   *  流式传输
   */
  static const int STREAM = 0;

  /**
   *  一次性传输
   */
  static const int ONCE = 1;
}

class TAIOralEvaluationEvalMode {
  /**
   *  单词模式
   */
  static const int WORD = 0;

  /**
   *  句子模式
   */
  static const int SENTENCE = 1;

  /**
   *  段落模式
   */
  static const int PARAGRAPH = 2;

  /**
   *  自由说模式
   */
  static const int FREE = 3;
}

class TAIOralEvaluationStorageMode {
  static const int DISABLE = 0;
  static const int ENABLE = 1;
}

class TAIOralEvaluationServerType {
  static const int ENGLISH = 0;
  static const int CHINESE = 1;
}

class TAIOralEvaluationTextMode {
  /**
   *  普通文本
   */
  static const int NORMAL = 0;

  /**
   *  音素结构文本
   */
  static const int PHONEME = 1;
}
