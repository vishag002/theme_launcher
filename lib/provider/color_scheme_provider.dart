import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme provider to manage app-wide theme
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier()
      : super(
          ThemeData(
            primaryColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: Colors.white,
              secondary: Colors.black,
            ),
          ),
        );

  void updateTheme(Color primaryColor, Color secondaryColor) {
    state = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: secondaryColor),
        bodyMedium: TextStyle(color: secondaryColor),
        titleLarge: TextStyle(color: secondaryColor),
        titleMedium: TextStyle(color: secondaryColor),
        titleSmall: TextStyle(color: secondaryColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(color: secondaryColor, fontSize: 20),
        iconTheme: IconThemeData(color: secondaryColor),
      ),
    );
  }
}
