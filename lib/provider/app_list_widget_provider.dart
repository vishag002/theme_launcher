import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_launcher/controller/app_screen_controller.dart';
import 'package:theme_launcher/widgets/home_screen_lists/apps_list_widget1.dart';

// Provider to keep track of selected widget index
final selectedAppListWidgetProvider = StateProvider<int>((ref) => 0);

// Provider that returns a list of app list widgets
final appListProviderUser = Provider<List<ConsumerWidget>>((ref) {
  final favoriteApps = ref.watch(appsProvider).favoriteApps;

  return [
    AppsListWidget1(favoriteApps: favoriteApps.cast<String>()),
    AppsListWidget2(favoriteApps: favoriteApps.cast<String>()),
    AppsListWidget3(favoriteApps: favoriteApps.cast<String>()),
    AppsListWidget4(favoriteApps: favoriteApps.cast<String>()),
    AppsListWidget5(favoriteApps: favoriteApps.cast<String>()),
  ];
});
final appListProviderDemo = Provider<List<ConsumerWidget>>((ref) {
  final apps = [
    'com.android.chrome',
    'com.google.android.gm',
    'com.google.android.youtube',
    'com.google.android.apps.maps',
  ];
  return [
    AppsListWidget1(favoriteApps: apps),
    AppsListWidget2(favoriteApps: apps),
    AppsListWidget3(favoriteApps: apps),
    AppsListWidget4(favoriteApps: apps),
    AppsListWidget5(favoriteApps: apps),
  ];
});
