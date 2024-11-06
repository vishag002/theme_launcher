import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:theme_launcher/controller/app_screen_controller.dart';
import 'package:theme_launcher/provider/app_icon_provider.dart';
import 'package:theme_launcher/views/settings_screen.dart';
import 'package:theme_launcher/widgets/app_info_popUP_widget.dart';

class AppListScreen extends ConsumerWidget {
  const AppListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Empty functions as placeholders

    final appsState = ref.watch(appsProvider);

    Widget buildAppItem(dynamic app, AsyncValue<String?> iconAsync) {
      return iconAsync.when(
        data: (iconPath) {
          final appIcon = iconPath != null
              ? Image.file(
                  File(iconPath),
                  width: 30,
                  height: 30,
                )
              : const Icon(Icons.apps);

          final appName = Text(
            app['appName'] ?? 'Unknown App',
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: appsState.viewType == ViewType.grid
                ? TextAlign.center
                : TextAlign.left,
            overflow: TextOverflow.fade,
            maxLines: 1,
          );

          return InkWell(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleAlertDialogWidget(
                    appName: app['appName'] ?? 'Unknown App',
                    onAddToHomeScreen: () => ref
                        .read(appsProvider.notifier)
                        .addToHomeScreen(app['packageName'], context),
                    onHideApp: () => ref
                        .read(appsProvider.notifier)
                        .hideApp(app['packageName'], context),
                    onUninstallApp: () => ref
                        .read(appsProvider.notifier)
                        .uninstallApp(app['packageName'], context),
                    onAppInfo: () => ref
                        .read(appsProvider.notifier)
                        .appInfo(app['packageName'], context),
                  );
                },
              );
            },
            onTap: () =>
                ref.read(appsProvider.notifier).launchApp(app['packageName']),
            child: appsState.viewType == ViewType.grid
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: appIcon,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: appName,
                      ),
                    ],
                  )
                : ListTile(
                    leading: appIcon,
                    title: appName,
                  ),
          );
        },
        loading: () => appsState.viewType == ViewType.grid
            ? const Center(child: CircularProgressIndicator())
            : ListTile(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleAlertDialogWidget(
                        appName: app['appName'] ?? 'Unknown App',
                        onAddToHomeScreen: () => ref
                            .read(appsProvider.notifier)
                            .addToHomeScreen(app['packageName'], context),
                        onHideApp: () => ref
                            .read(appsProvider.notifier)
                            .hideApp(app['packageName'], context),
                        onUninstallApp: () => ref
                            .read(appsProvider.notifier)
                            .uninstallApp(app['packageName'], context),
                        onAppInfo: () => ref
                            .read(appsProvider.notifier)
                            .appInfo(app['packageName'], context),
                      );
                    },
                  );
                },
                leading: CircularProgressIndicator(),
                title: Text('Loading...'),
              ),
        error: (error, stack) => appsState.viewType == ViewType.grid
            ? const Center(child: Icon(Icons.error))
            : ListTile(
                leading: const Icon(Icons.error),
                title: Text('Error: $error'),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Apps'),
        actions: [
          IconButton(
            icon: Icon(appsState.viewType == ViewType.grid
                ? Icons.list
                : Icons.grid_view),
            onPressed: () => ref.read(appsProvider.notifier).toggleViewType(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(appsProvider.notifier).loadApps(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const SettingsScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: appsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : appsState.error != null
                    ? Center(child: Text(appsState.error!))
                    : appsState.apps.isEmpty
                        ? const Center(child: Text('No apps found'))
                        : appsState.viewType == ViewType.grid
                            ? GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: appsState.apps.length,
                                itemBuilder: (context, index) {
                                  final app = appsState.apps[index];
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      final iconAsync = ref.watch(
                                          appIconProvider(app['packageName']));
                                      return buildAppItem(app, iconAsync);
                                    },
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: appsState.apps.length,
                                itemBuilder: (context, index) {
                                  final app = appsState.apps[index];
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      final iconAsync = ref.watch(
                                          appIconProvider(app['packageName']));
                                      return buildAppItem(app, iconAsync);
                                    },
                                  );
                                },
                              ),
          ),
        ],
      ),
    );
  }
}
