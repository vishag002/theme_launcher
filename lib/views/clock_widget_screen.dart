import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_launcher/provider/clock_widget_provider.dart';
import 'package:theme_launcher/widgets/carouseL_widget.dart';

// Provider to track the selected clock widget index
final selectedClockWidgetProvider = StateProvider<int>((ref) => 0);

class ClockWidgetScreen extends ConsumerWidget {
  const ClockWidgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockWidgetsList = ref.watch(clockWidgetListProvider);
    final selectedClockIndex = ref.watch(selectedClockWidgetProvider);

    // Convert clock widgets to CarouselItems
    final carouselItems = List.generate(
      clockWidgetsList.length,
      (index) => CarouselItem<int>(
        data: index,
        builder: (data, isSelected) => Container(
          height: 350,
          width: 300,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: clockWidgetsList[index]),
        ),
      ),
    );

    return SelectionCarousel<int>(
      title: "Clock Widgets",
      items: carouselItems,
      initialIndex: selectedClockIndex,
      aspectRatio: 0.85,
      viewportFraction: 0.8,
      itemHeight: 350,
      itemWidth: 300,
      onSelect: (selectedIndex) async {
        // Update selected clock widget
        ref.read(selectedClockWidgetProvider.notifier).state = selectedIndex;

        // Save the selection to SharedPreferences
        await _saveSelectedClockIndex(selectedIndex);
      },
    );
  }

  // Save selected clock index to SharedPreferences
  Future<void> _saveSelectedClockIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedClockIndex', index);
  }
}
