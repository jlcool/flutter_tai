package com.jlcool.flutter_tai;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.text.TextUtils;
import android.view.View;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.google.gson.Gson;
import com.tencent.taisdk.TAIErrCode;
import com.tencent.taisdk.TAIError;
import com.tencent.taisdk.TAIOralEvaluation;
import com.tencent.taisdk.TAIOralEvaluationCallback;
import com.tencent.taisdk.TAIOralEvaluationData;
import com.tencent.taisdk.TAIOralEvaluationEvalMode;
import com.tencent.taisdk.TAIOralEvaluationFileType;
import com.tencent.taisdk.TAIOralEvaluationListener;
import com.tencent.taisdk.TAIOralEvaluationParam;
import com.tencent.taisdk.TAIOralEvaluationRet;
import com.tencent.taisdk.TAIOralEvaluationServerType;
import com.tencent.taisdk.TAIOralEvaluationStorageMode;
import com.tencent.taisdk.TAIOralEvaluationTextMode;
import com.tencent.taisdk.TAIOralEvaluationWorkMode;
import com.tencent.taisdk.TAIRecorderParam;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * FlutterTaiPlugin
 */
public class FlutterTaiPlugin implements MethodCallHandler {
    private static Context _context;
    private static MethodChannel _channel;
    private final Activity activity;
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        _context = registrar.context();
        _channel = new MethodChannel(registrar.messenger(), "flutter_tai");
        _channel.setMethodCallHandler(new FlutterTaiPlugin(registrar, registrar.activity()));
    }
    private FlutterTaiPlugin(Registrar registrar, Activity activity) {
        this.activity=activity;
    }
    private TAIOralEvaluation _oral = new TAIOralEvaluation();

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("record")) {
            onRecord(call, result);
        } else if (call.method.equals("stop")) {
            onStop(call, result);
        } else{
            result.notImplemented();
        }
    }

    public void onStop(final MethodCall call, final Result result) {
        final String _id= call.argument("id");
        if (_oral.isRecording()) {
            _oral.stopRecordAndEvaluation(new TAIOralEvaluationCallback() {
                @Override
                public void onResult(final TAIError error) {
                    Gson gson = new Gson();
                    String string = gson.toJson(error);
                    final Map<String, String> _data = new HashMap();
                    _data.put("id", _id);
                    _data.put("err", string);
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    _channel.invokeMethod("onStop", _data);
                                }
                            });

                }
            });
        }
    }
    public void onRecord(final MethodCall call, final Result result) {

        final Result _result = result;
        final String _id= call.argument("id");
        if (_oral == null) {
            _oral = new TAIOralEvaluation();
        }
        if (_oral.isRecording()) {
            _oral.stopRecordAndEvaluation(new TAIOralEvaluationCallback() {
                @Override
                public void onResult(final TAIError error) {
                    Gson gson = new Gson();
                    String string = gson.toJson(error);
                    final Map<String, String> _data = new HashMap();
                    _data.put("id", _id);
                    _data.put("err", string);
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    _channel.invokeMethod("onStop", _data);
                                }
                     });

                }
            });
        } else {
            final String mp3FileName = String.format("taisdk_%d.mp3", System.currentTimeMillis() / 1000);
            _oral.setListener(new TAIOralEvaluationListener() {
                @Override
                public void onEvaluationData(final TAIOralEvaluationData data, final TAIOralEvaluationRet result, final TAIError error) {
                    writeFileToSDCard(data.audio, "com.tencent.taidemo", mp3FileName, true, false);
                    Gson gson = new Gson();
                    String errString = gson.toJson(error);
                    String retString = gson.toJson(result);
                    final Map<String, String> _data = new HashMap();
                    _data.put("seqId", String.valueOf(data.seqId));
                    _data.put("end", String.valueOf(data.bEnd ? 1 : 0));
                    _data.put("err", errString);
                    _data.put("ret", retString);
                    _data.put("id", _id);
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    _channel.invokeMethod("onEvaluationData", _data);
                                }
                            });

                }

                @Override
                public void onEndOfSpeech() {
                    onRecord(call, result);
                }

                @Override
                public void onVolumeChanged(final int volume) {
                    final Map<String, String> _data = new HashMap();
                    _data.put("volume", String.valueOf(volume));
                    _data.put("id", _id);
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    _channel.invokeMethod("onProgress", _data);
                                }
                            });

                }
            });

            TAIOralEvaluationParam param = new TAIOralEvaluationParam();
            param.context = _context;
            param.sessionId = UUID.randomUUID().toString();
            param.appId = call.argument("appId");
            param.soeAppId = call.argument("soeAppId");
            param.secretId = call.argument("secretId");
            param.secretKey = call.argument("secretKey");
            param.token = call.argument("token");

            param.workMode = call.argument("workMode");
            param.evalMode = call.argument("evalMode");
            param.storageMode = call.argument("storageMode");
            param.fileType = TAIOralEvaluationFileType.MP3;
            param.serverType = call.argument("serverType");
            param.textMode = call.argument("textMode");
            param.scoreCoeff = call.argument("scoreCoeff");
            param.refText = call.argument("refText");
            if (param.workMode == TAIOralEvaluationWorkMode.STREAM) {
                param.timeout = call.argument("timeout");
                param.retryTimes = call.argument("retryTimes");
            } else {
                param.timeout = call.argument("timeout");
                param.retryTimes = call.argument("retryTimes");
            }
            TAIRecorderParam recordParam = new TAIRecorderParam();
            recordParam.fragSize = call.argument("fragSize");
            recordParam.fragEnable = call.argument("fragEnable");
            recordParam.vadEnable = call.argument("vadEnable");
            recordParam.vadInterval = call.argument("vadInterval");
            _oral.setRecorderParam(recordParam);
            _oral.startRecordAndEvaluation(param, new TAIOralEvaluationCallback() {
                @Override
                public void onResult(final TAIError error) {
                    Gson gson = new Gson();
                    String string = gson.toJson(error);
                    final Map<String, String> _data = new HashMap();
                    _data.put("err", string);
                    _data.put("id", _id);
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    _channel.invokeMethod("onResult", _data);
                                }
                            });

                }
            });
        }
    }

    public synchronized static void writeFileToSDCard(final byte[] buffer, final String folder,
                                                      final String fileName, final boolean append, final boolean autoLine) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                boolean sdCardExist = Environment.getExternalStorageState().equals(
                        android.os.Environment.MEDIA_MOUNTED);
                String folderPath = "";
                if (sdCardExist) {
                    //TextUtils为android自带的帮助类
                    if (TextUtils.isEmpty(folder)) {
                        //如果folder为空，则直接保存在sd卡的根目录
                        folderPath = Environment.getExternalStorageDirectory()
                                + File.separator;
                    } else {
                        folderPath = Environment.getExternalStorageDirectory()
                                + File.separator + folder + File.separator;
                    }
                } else {
                    return;
                }


                File fileDir = new File(folderPath);
                if (!fileDir.exists()) {
                    if (!fileDir.mkdirs()) {
                        return;
                    }
                }
                File file;
                //判断文件名是否为空
                if (TextUtils.isEmpty(fileName)) {
                    file = new File(folderPath + "app_log.txt");
                } else {
                    file = new File(folderPath + fileName);
                }
                RandomAccessFile raf = null;
                FileOutputStream out = null;
                try {
                    if (append) {
                        //如果为追加则在原来的基础上继续写文件
                        raf = new RandomAccessFile(file, "rw");
                        raf.seek(file.length());
                        raf.write(buffer);
                        if (autoLine) {
                            raf.write("\n".getBytes());
                        }
                    } else {
                        //重写文件，覆盖掉原来的数据
                        out = new FileOutputStream(file);
                        out.write(buffer);
                        out.flush();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (raf != null) {
                            raf.close();
                        }
                        if (out != null) {
                            out.close();
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }
}
