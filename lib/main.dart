import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:theme_launcher/provider/color_scheme_provider.dart';
import 'package:theme_launcher/views/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return GetMaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
