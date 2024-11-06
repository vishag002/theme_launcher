import 'package:flutter/services.dart';

class AppInfoHelper {
  static const MethodChannel _channel =
      MethodChannel('com.example.theme_launcher.app/info');

  static Future<void> openAppInfo(String packageName) async {
    try {
      await _channel.invokeMethod('openAppInfo', {'packageName': packageName});
    } on PlatformException catch (e) {
      // Handle or log the error
    }
  }
}
