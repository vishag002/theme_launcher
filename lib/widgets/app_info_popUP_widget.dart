import 'package:flutter/material.dart';

class SimpleAlertDialogWidget extends StatelessWidget {
  final String appName;
  final Function onAddToHomeScreen;
  final Function onHideApp;
  final Function onUninstallApp;
  final Function onAppInfo;

  const SimpleAlertDialogWidget({
    Key? key,
    required this.appName,
    required this.onAddToHomeScreen,
    required this.onHideApp,
    required this.onUninstallApp,
    required this.onAppInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.1,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFunctionTile(
                    'Add to homescreen', onAddToHomeScreen, context),
                _buildFunctionTile('Hide', onHideApp, context),
                _buildFunctionTile('Uninstall', onUninstallApp, context),
                _buildFunctionTile('App info', onAppInfo, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionTile(String title, Function onTap, context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 16),
      ),
      onTap: () => onTap(),
      contentPadding: EdgeInsets.zero,
    );
  }
}
