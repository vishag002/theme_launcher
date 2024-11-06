import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_launcher/services/app_info_service.dart';
import 'package:theme_launcher/services/native_service.dart';

// State class to handle loading and error states
enum ViewType { grid, list }

// Updated AppsState class to manage hidden and favorite apps
class AppsState {
  final List<dynamic> apps;
  final List<dynamic> favoriteApps; // List to track favorite apps
  final List<dynamic> hiddenApps; // List to track hidden apps
  final bool isLoading;
  final String? error;
  final ViewType viewType;

  AppsState({
    required this.apps,
    this.favoriteApps = const [],
    this.hiddenApps = const [],
    this.isLoading = false,
    this.error,
    this.viewType = ViewType.grid,
  });

  AppsState copyWith({
    List<dynamic>? apps,
    List<dynamic>? favoriteApps,
    List<dynamic>? hiddenApps,
    bool? isLoading,
    String? error,
    ViewType? viewType,
  }) {
    return AppsState(
      apps: apps ?? this.apps,
      favoriteApps: favoriteApps ?? this.favoriteApps,
      hiddenApps: hiddenApps ?? this.hiddenApps,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewType: viewType ?? this.viewType,
    );
  }
}

// Updated AppsNotifier class
class AppsNotifier extends StateNotifier<AppsState> {
  final LauncherService _launcherService;
  static const String favoriteAppsKey = 'favorite_apps';

  AppsNotifier(this._launcherService) : super(AppsState(apps: [])) {
    loadApps();
    loadFavoriteApps(); // Load favorites from shared preferences
  }
  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.grid ? ViewType.list : ViewType.grid,
    );
  }

  Future<void> loadApps() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final apps = await _launcherService.getInstalledApps();

      if (apps != null) {
        apps.sort((a, b) {
          final nameA = (a['appName'] ?? 'Unknown App').trim().toLowerCase();
          final nameB = (b['appName'] ?? 'Unknown App').trim().toLowerCase();
          return nameA.compareTo(nameB);
        });
      }

      state = state.copyWith(
        apps: apps,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load apps: $e',
      );
    }
  }

  Future<void> launchApp(String packageName) async {
    await _launcherService.launchApp(packageName);
  }

  Future<void> uninstallApp(String packageName, context) async {
    await _launcherService.uninstallApp(packageName);
    Navigator.pop(context);
    loadApps(); // Reload the apps list after uninstalling
  }

  // Load favorite apps from shared preferences
  Future<void> loadFavoriteApps() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList(favoriteAppsKey) ?? [];
    state = state.copyWith(favoriteApps: storedFavorites);
  }

  // Save favorite apps to shared preferences
  Future<void> saveFavoriteApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        favoriteAppsKey, List<String>.from(state.favoriteApps));
  }

  // Add to home screen (favorite)
  Future<void> addToHomeScreen(String packageName, context) async {
    final updatedFavorites = List.from(state.favoriteApps);
    if (!updatedFavorites.contains(packageName)) {
      updatedFavorites.add(packageName);
      state = state.copyWith(favoriteApps: updatedFavorites);
      await saveFavoriteApps(); // Save updated favorites to shared preferences
    }
    Navigator.pop(context);
  }

  // Remove from home screen (unfavorite)
  Future<void> removeFromHomeScreen(String packageName, context) async {
    final updatedFavorites = List.from(state.favoriteApps);
    updatedFavorites.remove(packageName);
    state = state.copyWith(favoriteApps: updatedFavorites);
    await saveFavoriteApps(); // Save updated favorites to shared preferences
  }

  // Hide app
  Future<void> hideApp(String packageName, context) async {
    final updatedHiddenApps = List.from(state.hiddenApps);
    if (!updatedHiddenApps.contains(packageName)) {
      updatedHiddenApps.add(packageName);
    }
    state = state.copyWith(hiddenApps: updatedHiddenApps);
    Navigator.pop(context);
  }

  Future<void> closeApp(String packageName) async {
    await _launcherService.closeApp(packageName);
  }

  Future<void> appInfo(String packageName, context) async {
    AppInfoHelper.openAppInfo(packageName);
    Navigator.pop(context);
  }
}

// Providers
final launcherServiceProvider = Provider((ref) => LauncherService());

final appsProvider = StateNotifierProvider<AppsNotifier, AppsState>((ref) {
  final launcherService = ref.watch(launcherServiceProvider);
  return AppsNotifier(launcherService);
});

///
final filteredAppsProvider = Provider<List<dynamic>>((ref) {
  final appsState = ref.watch(appsProvider);
  return appsState.apps
      .where((app) => !appsState.hiddenApps.contains(app['packageName']))
      .toList();
});
