import 'package:flutter/services.dart';

class LauncherService {
  static const platform = MethodChannel('com.example.theme_launcher/launcher');

  Future<List<dynamic>> getInstalledApps() async {
    try {
      final List<dynamic> apps =
          await platform.invokeMethod('getInstalledApps');
      return apps;
    } on PlatformException catch (e) {
      print('Failed to get installed apps: ${e.message}');
      return [];
    }
  }

  Future<void> launchApp(String packageName) async {
    try {
      await platform.invokeMethod('launchApp', {'packageName': packageName});
    } on PlatformException catch (e) {
      print('Failed to launch app: ${e.message}');
    }
  }

  Future<void> uninstallApp(String packageName) async {
    try {
      await platform.invokeMethod('uninstallApp', {'packageName': packageName});
    } on PlatformException catch (e) {
      print('Failed to uninstall app: ${e.message}');
    }
  }

  Future<void> closeApp(String packageName) async {
    try {
      await platform.invokeMethod('closeApp', {'packageName': packageName});
    } on PlatformException catch (e) {
      print('Failed to close app: ${e.message}');
    }
  }
}
