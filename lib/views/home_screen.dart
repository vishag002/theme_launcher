import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_launcher/controller/app_screen_controller.dart';
import 'package:theme_launcher/provider/app_icon_provider.dart';
import 'package:theme_launcher/provider/clock_widget_provider.dart';

final selectedClockWidgetProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  Future<int> _loadSelectedClockIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedClockIndex') ?? 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final appsState = ref.watch(appsProvider);
    final favoriteApps = appsState.favoriteApps;

    //
    final clockWidgetsList = ref.watch(clockWidgetListProvider);
    final selectedClockIndex = ref.watch(selectedClockWidgetProvider);

    // Initialize the selected index on the first build
    _loadSelectedClockIndex().then((savedIndex) {
      ref.read(selectedClockWidgetProvider.notifier).state = savedIndex;
    });

    final h1 = MediaQuery.of(context).size.height;
    final w1 = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://i0.wp.com/www.3wallpapers.fr/wp-content/uploads/2018/04/iPhone-wallpaper-bmw-black.jpg?w=1080&ssl=1'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                //color: Colors.amber,
                height: 50,
              ),
              Container(
                //color: Colors.amber,
                height: h1 * 0.23,
                width: w1,
                child: Center(
                  child: clockWidgetsList[selectedClockIndex],
                ),
              ),
              Expanded(
                // TODO:favorite apps list
                child: Container(
                  width: w1,
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

                            final appName =
                                appData?['appName'] ?? 'Unknown App';

                            return ListTile(
                              textColor: Colors.white,
                              leading: appIconAsyncValue.when(
                                data: (iconPath) => CircleAvatar(
                                  radius: 20,
                                  backgroundImage: iconPath != null
                                      ? FileImage(File(iconPath))
                                      : null, // Use a default image or color if icon is not available
                                  backgroundColor: iconPath == null
                                      ? Colors.grey
                                      : Colors.transparent,
                                ),
                                loading: () => CircularProgressIndicator(),
                                error: (_, __) => CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors
                                      .grey, // Fallback color in case of error
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                              ),
                              title: Text(appName),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(appsProvider.notifier)
                                      .removeFromHomeScreen(
                                          appPackageName, context);
                                },
                              ),
                              onTap: () {
                                ref
                                    .read(appsProvider.notifier)
                                    .launchApp(appPackageName);
                              },
                            );
                          }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
