//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//class PermissionUtil {
//  static Future<bool> checkStorage() async {
//    if (Platform.isAndroid) {
//      PermissionStatus permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
//      if (permission != PermissionStatus.granted) {
//        Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler()
//            .requestPermissions([PermissionGroup.storage]);
//        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//          return true;
//        }
//      } else {
//        return true;
//      }
//    } else {
//      return true;
//    }
//    return false;
//  }
//
//  static Future<bool> checkMicrophone(BuildContext context) async {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.microphone);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissions =
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.microphone]);
//      if (permissions[PermissionGroup.microphone] == PermissionStatus.granted) {
//        return true;
//      }
//    } else {
//      return true;
//    }
//    return false;
//  }
//
//  static Future<bool> checkPhoto(BuildContext context) async {
//    if (Platform.isIOS) {
//      PermissionStatus permission = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.photos);
//      if (permission != PermissionStatus.granted) {
//        Map<PermissionGroup, PermissionStatus> permissions =
//        await PermissionHandler()
//            .requestPermissions([PermissionGroup.photos]);
//        if (permissions[PermissionGroup.photos] == PermissionStatus.granted) {
//          return true;
//        }
//      } else {
//        return true;
//      }
//      return false;
//    } else {
//      return true;
//    }
//  }
//}
