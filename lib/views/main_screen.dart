import 'package:flutter/material.dart';
import 'package:theme_launcher/views/apps_screen.dart';
import 'package:theme_launcher/views/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical, // Set vertical scroll
        children: [
          HomeScreen(), // First screen
          AppListScreen(), // Second screen
        ],
      ),
    );
  }
}
