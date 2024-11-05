import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_launcher/controller/time_controller.dart';
import 'package:theme_launcher/views/clock_widget_screen.dart';
import 'package:theme_launcher/widgets/clock%20widgets/clock_widget_1.dart';

final selectedClockWidgetProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<int> _loadSelectedClockIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedClockIndex') ?? 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerModel = ref.watch(timerControllerProvider);
    final selectedClockIndex = ref.watch(selectedClockWidgetProvider);

    // List of available clock widgets
    final List clockWidgetsList = [
      ClockWidget1(timerModel: timerModel),
      ClockWidget2(timerModel: timerModel),
      ClockWidget3(timerModel: timerModel),
      ClockWidget4(timerModel: timerModel),
      ClockWidget5(timerModel: timerModel),
    ];

    // Initialize the selected index on the first build
    _loadSelectedClockIndex().then((savedIndex) {
      ref.read(selectedClockWidgetProvider.notifier).state = savedIndex;
    });

    final h1 = MediaQuery.of(context).size.height;
    final w1 = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: h1 * 0.23,
            width: w1,
            child: Center(
              child: clockWidgetsList[selectedClockIndex],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ClockWidgetScreen
          Get.to(() => const ClockWidgetScreen());
        },
        child: const Icon(Icons.watch),
      ),
    );
  }
}
