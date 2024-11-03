import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_launcher/services/native_service.dart';

// State class to handle loading and error states
enum ViewType { grid, list }

class AppsState {
  final List<dynamic> apps;
  final bool isLoading;
  final String? error;
  final ViewType viewType; // Add this line

  AppsState({
    required this.apps,
    this.isLoading = false,
    this.error,
    this.viewType = ViewType.grid, // Default to grid view
  });

  AppsState copyWith({
    List<dynamic>? apps,
    bool? isLoading,
    String? error,
    ViewType? viewType,
  }) {
    return AppsState(
      apps: apps ?? this.apps,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewType: viewType ?? this.viewType,
    );
  }
}

// Apps notifier to handle state changes (business logic)
class AppsNotifier extends StateNotifier<AppsState> {
  final LauncherService _launcherService;

  AppsNotifier(this._launcherService) : super(AppsState(apps: [])) {
    loadApps();
  }

//toggle apps
  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.grid ? ViewType.list : ViewType.grid,
    );
  }

  Future<void> loadApps() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final apps = await _launcherService.getInstalledApps();
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

  Future<void> uninstallApp(String packageName) async {
    await _launcherService.uninstallApp(packageName);
    loadApps();
  }

  Future<void> closeApp(String packageName) async {
    await _launcherService.closeApp(packageName);
  }
}

// Providers
final launcherServiceProvider = Provider((ref) => LauncherService());

final appsProvider = StateNotifierProvider<AppsNotifier, AppsState>((ref) {
  final launcherService = ref.watch(launcherServiceProvider);
  return AppsNotifier(launcherService);
});
