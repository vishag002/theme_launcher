import 'package:flutter/services.dart';

class NotificationPanelService {
  static const platform =
      MethodChannel('com.example.theme_launcher/notification_panel');

  static Future<void> openNotificationPanel() async {
    try {
      await platform.invokeMethod('openNotificationPanel');
    } on PlatformException catch (e) {
      print("Failed to open notification panel: '${e.message}'.");
    }
  }
}
