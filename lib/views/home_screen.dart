import 'dart:io'; // Impor0t for File
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theme_launcher/controller/native_service.dart';

class AppListScreen extends StatefulWidget {
  const AppListScreen({super.key});

  @override
  _AppListScreenState createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  final LauncherService _launcherService = LauncherService();
  List<dynamic> _apps = [];
  List<dynamic> _filteredApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInstalledApps();
  }

  Future<void> _loadInstalledApps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apps = await _launcherService.getInstalledApps();
      setState(() {
        _apps = apps;
        _filteredApps = apps;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading apps: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getIconPath(String packageName) async {
    final cacheDir = await getApplicationDocumentsDirectory();
    final iconFile = File('${cacheDir.path}/$packageName.png');

    if (await iconFile.exists()) {
      return iconFile.path;
    }

    try {
      final appInfo = await InstalledApps.getAppInfo(
          packageName); // Assume this method retrieves app info
      if (appInfo?.icon != null) {
        await iconFile.writeAsBytes(appInfo!.icon!);
        return iconFile.path;
      }
    } catch (e) {
      print("Error saving icon for $packageName: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Apps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInstalledApps,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredApps.isEmpty
                    ? const Center(child: Text('No apps found'))
                    : ListView.builder(
                        itemCount: _filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = _filteredApps[index];
                          return FutureBuilder<String?>(
                            future: _getIconPath(app['packageName']),
                            builder: (context, snapshot) {
                              Widget leadingWidget;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                leadingWidget =
                                    const CircularProgressIndicator(); // Show a loading indicator while fetching
                              } else if (snapshot.hasError ||
                                  snapshot.data == null) {
                                leadingWidget =
                                    const Icon(Icons.apps); // Fallback icon
                              } else {
                                leadingWidget = Image.file(
                                  File(snapshot.data!),
                                  width: 40,
                                  height: 40,
                                );
                              }

                              return ListTile(
                                leading: leadingWidget,
                                title: Text(
                                  app['appName'] ?? 'Unknown App',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                // subtitle: Text(
                                //   app['packageName'] ?? 'Unknown Package',
                                //   style: const TextStyle(fontSize: 12),
                                // ),
                                // trailing: PopupMenuButton<String>(
                                //   onSelected: (value) {
                                //     switch (value) {
                                //       case 'launch':
                                //         _launcherService
                                //             .launchApp(app['packageName']);
                                //         break;
                                //       case 'uninstall':
                                //         _launcherService
                                //             .uninstallApp(app['packageName']);
                                //         break;
                                //       case 'close':
                                //         _launcherService
                                //             .closeApp(app['packageName']);
                                //         break;
                                //     }
                                //   },
                                //   itemBuilder: (BuildContext context) => [
                                //     const PopupMenuItem(
                                //       value: 'launch',
                                //       child: Row(
                                //         children: [
                                //           Icon(Icons.launch, size: 20),
                                //           SizedBox(width: 8),
                                //           Text('Launch'),
                                //         ],
                                //       ),
                                //     ),
                                //     const PopupMenuItem(
                                //       value: 'uninstall',
                                //       child: Row(
                                //         children: [
                                //           Icon(Icons.delete_outline, size: 20),
                                //           SizedBox(width: 8),
                                //           Text('Uninstall'),
                                //         ],
                                //       ),
                                //     ),
                                //     const PopupMenuItem(
                                //       value: 'close',
                                //       child: Row(
                                //         children: [
                                //           Icon(Icons.close, size: 20),
                                //           SizedBox(width: 8),
                                //           Text('Close'),
                                //         ],
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                onTap: () => _launcherService
                                    .launchApp(app['packageName']),
                              );
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
