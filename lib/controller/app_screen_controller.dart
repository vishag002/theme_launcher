import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:path_provider/path_provider.dart';

// Define the state of the installed apps
class AppListState {
  final List<dynamic> apps;
  final bool isLoading;

  AppListState({this.apps = const [], this.isLoading = false});
}

// Create a StateNotifier to manage the apps
class AppListNotifier extends StateNotifier<AppListState> {
  AppListNotifier() : super(AppListState());

  Future<void> loadInstalledApps() async {
    state = AppListState(isLoading: true);
    try {
      final apps = await InstalledApps.getInstalledApps();
      state = AppListState(apps: apps);
    } catch (e) {
      print('Error loading apps: $e');
      state = AppListState(apps: [], isLoading: false);
    }
  }

  Future<String?> getIconPath(String packageName) async {
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
  }
}

// Create a provider for the AppListNotifier
final appListProvider = StateNotifierProvider<AppListNotifier, AppListState>(
  (ref) => AppListNotifier(),
);
