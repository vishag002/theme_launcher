import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:path_provider/path_provider.dart';

final appIconProvider =
    FutureProvider.family<String?, String>((ref, packageName) async {
  final cacheDir = await getApplicationDocumentsDirectory();
  final iconFile = File('${cacheDir.path}/$packageName.png');

  if (await iconFile.exists()) {
    return iconFile.path;
  }

  try {
    final appInfo = await InstalledApps.getAppInfo(packageName);
    if (appInfo?.icon != null) {
      await iconFile.writeAsBytes(appInfo!.icon!);
      return iconFile.path;
    }
  } catch (e) {
    print("Error saving icon for $packageName: $e");
  }

  return null;
});
