import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_launcher/controller/app_screen_controller.dart';
import 'package:theme_launcher/provider/app_icon_provider.dart';

class AppsListWidget1 extends ConsumerWidget {
  final List<String> favoriteApps; // Required parameter for apps list

  const AppsListWidget1({
    Key? key,
    required this.favoriteApps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(appsProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: favoriteApps.isEmpty
          ? Center(child: Text('No apps added to home screen'))
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteApps.length,
              itemBuilder: (context, index) {
                final appPackageName = favoriteApps[index];
                final appIconAsyncValue =
                    ref.watch(appIconProvider(appPackageName));

                // Find the app data by package name in the full apps list
                final appData = appsState.apps.firstWhere(
                  (app) => app['packageName'] == appPackageName,
                  orElse: () => null,
                );

                final appName = appData?['appName'] ?? 'Unknown App';

                return ListTile(
                  textColor: Colors.white,
                  leading: appIconAsyncValue.when(
                    data: (iconPath) => CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          iconPath != null ? FileImage(File(iconPath)) : null,
                      backgroundColor:
                          iconPath == null ? Colors.grey : Colors.transparent,
                    ),
                    loading: () => CircularProgressIndicator(),
                    error: (_, __) => CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                  title: Text(appName),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      ref
                          .read(appsProvider.notifier)
                          .removeFromHomeScreen(appPackageName, context);
                    },
                  ),
                  onTap: () {
                    ref.read(appsProvider.notifier).launchApp(appPackageName);
                  },
                );
              }),
    );
  }
}

////
class AppsListWidget2 extends ConsumerWidget {
  final List<String> favoriteApps;

  const AppsListWidget2({Key? key, required this.favoriteApps})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(appsProvider);

    return favoriteApps.isEmpty
        ? Center(child: Text('No apps added to home screen'))
        : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: favoriteApps.length,
            itemBuilder: (context, index) {
              final appPackageName = favoriteApps[index];
              final appIconAsyncValue =
                  ref.watch(appIconProvider(appPackageName));

              return GestureDetector(
                onTap: () =>
                    ref.read(appsProvider.notifier).launchApp(appPackageName),
                child: appIconAsyncValue.when(
                  data: (iconPath) => CircleAvatar(
                    radius: 15,
                    backgroundImage:
                        iconPath != null ? FileImage(File(iconPath)) : null,
                    backgroundColor:
                        iconPath == null ? Colors.grey : Colors.transparent,
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (_, __) => Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          );
  }
}

///
class AppsListWidget3 extends ConsumerWidget {
  final List<String> favoriteApps;

  const AppsListWidget3({Key? key, required this.favoriteApps})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(appsProvider);

    return favoriteApps.isEmpty
        ? Center(child: Text('No apps added to home screen'))
        : SizedBox(
            height: 100,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: favoriteApps.length,
              itemBuilder: (context, index) {
                final appPackageName = favoriteApps[index];
                final appIconAsyncValue =
                    ref.watch(appIconProvider(appPackageName));
                final appData = appsState.apps.firstWhere(
                  (app) => app['packageName'] == appPackageName,
                  orElse: () => null,
                );
                final appName = appData?['appName'] ?? 'Unknown App';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appIconAsyncValue.when(
                      data: (iconPath) => CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            iconPath != null ? FileImage(File(iconPath)) : null,
                        backgroundColor:
                            iconPath == null ? Colors.grey : Colors.transparent,
                      ),
                      loading: () => CircularProgressIndicator(),
                      error: (_, __) => Icon(Icons.error, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(appName,
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                );
              },
            ),
          );
  }
}

////
class AppsListWidget4 extends ConsumerWidget {
  final List<String> favoriteApps;

  const AppsListWidget4({Key? key, required this.favoriteApps})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(appsProvider);

    return favoriteApps.isEmpty
        ? Center(child: Text('No apps added to home screen'))
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: favoriteApps.length,
            itemBuilder: (context, index) {
              final appPackageName = favoriteApps[index];
              final appIconAsyncValue =
                  ref.watch(appIconProvider(appPackageName));
              final appData = appsState.apps.firstWhere(
                (app) => app['packageName'] == appPackageName,
                orElse: () => null,
              );
              final appName = appData?['appName'] ?? 'Unknown App';

              return Column(
                children: [
                  appIconAsyncValue.when(
                    data: (iconPath) => CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          iconPath != null ? FileImage(File(iconPath)) : null,
                      backgroundColor:
                          iconPath == null ? Colors.grey : Colors.transparent,
                    ),
                    loading: () => CircularProgressIndicator(),
                    error: (_, __) => Icon(Icons.error, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(appName,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Divider(color: Colors.grey),
                ],
              );
            },
          );
  }
}

///
class AppsListWidget5 extends ConsumerWidget {
  final List<String> favoriteApps;
  const AppsListWidget5({Key? key, required this.favoriteApps})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(appsProvider);

    return favoriteApps.isEmpty
        ? Center(child: Text('No apps added to home screen'))
        : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: favoriteApps.length,
            itemBuilder: (context, index) {
              final appPackageName = favoriteApps[index];
              final appIconAsyncValue =
                  ref.watch(appIconProvider(appPackageName));
              final appData = appsState.apps.firstWhere(
                (app) => app['packageName'] == appPackageName,
                orElse: () => null,
              );
              final appName = appData?['appName'] ?? 'Unknown App';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appIconAsyncValue.when(
                    data: (iconPath) => CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          iconPath != null ? FileImage(File(iconPath)) : null,
                      backgroundColor:
                          iconPath == null ? Colors.grey : Colors.transparent,
                    ),
                    loading: () => CircularProgressIndicator(),
                    error: (_, __) => Icon(Icons.error, color: Colors.white),
                  ),
                  if (index.isOdd) // Show app name only on odd indices
                    SizedBox(height: 5),
                  if (index.isOdd)
                    Text(appName,
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              );
            },
          );
  }
}
