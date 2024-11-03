import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_launcher/views/color_picker_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Color"),
            onTap: () {
              Get.to(ColorPickerScreen());
            },
          )
        ],
      ),
    );
  }
}
