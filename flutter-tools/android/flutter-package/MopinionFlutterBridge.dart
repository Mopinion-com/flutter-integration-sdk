import 'dart:collection';

import 'package:flutter/services.dart';

class MopinionFlutterBridge {
  static const platform = MethodChannel("MopinionFlutterBridge/native");

  static const eventAction = "trigger_event";
  static const initSdkAction = "init_sdk";
  static const addMetaDataAction = "add_meta_data";
  static const removeMetaDataAction = "remove_meta_data";
  static const removeAllMetaDataAction = "remove_all_meta_data";

  void initSdk(String deploymentKey, bool log) async {
    await platform.invokeMethod(initSdkAction, {
      "deployment_key": deploymentKey,
      "log": log
    });
  }

  Future<String> event(String eventName) async {
    return await platform.invokeMethod(eventAction, {
      "argument1": eventName
    });
  }

  void data(Map<String, String> map) async {
    map.forEach((key, value) {
      platform.invokeMethod(addMetaDataAction, {
        "key": key,
        "value": value
      });
    });
  }

  void removeMetaData(String key) async {
    platform.invokeMethod(removeMetaDataAction, {
      "key": key
    });
  }

  void removeAllMetaData() async {
    platform.invokeMethod(removeAllMetaDataAction);
  }

}