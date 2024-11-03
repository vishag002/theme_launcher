import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:theme_launcher/views/clock_widget_screen.dart';
import 'package:theme_launcher/views/favourite_list_widget.dart';

class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize your apps"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("set wallpaper"),
          ),
          ListTile(
            title: Text("clock widget"),
            onTap: () {
              Get.to(const ClockWidgetScreen());
            },
          ),
          ListTile(
            title: Text("list style"),
            onTap: () {
              Get.to(const FavouriteListWidget());
            },
          )
        ],
      ),
    );
  }
}
