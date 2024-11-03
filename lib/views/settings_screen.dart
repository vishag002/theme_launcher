import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_launcher/views/color_picker_screen.dart';
import 'package:theme_launcher/views/customization_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "Color",
              style: TextStyle(
                color: theme.colorScheme.secondary,
              ),
            ),
            onTap: () {
              Get.to(ColorPickerScreen());
            },
          ),
          ListTile(
            title: Text(
              "customize Appearance",
              style: TextStyle(
                color: theme.colorScheme.secondary,
              ),
            ),
            onTap: () {
              Get.to(CustomizationScreen());
            },
          )
        ],
      ),
    );
  }
}
