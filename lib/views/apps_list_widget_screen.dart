import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_launcher/provider/app_list_widget_provider.dart';
import 'package:theme_launcher/widgets/carouseL_widget.dart';

// Provider to track the selected app list widget index
final selectedAppListWidgetProvider = StateProvider<int>((ref) => 0);

class AppsListWidgetScreen extends ConsumerWidget {
  const AppsListWidgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWidgetsList = ref.watch(appListProviderDemo);
    final selectedAppListIndex = ref.watch(selectedAppListWidgetProvider);

    // Convert list widgets to CarouselItems
    final carouselItems = List.generate(
      appWidgetsList.length,
      (index) => CarouselItem<int>(
        data: index,
        builder: (data, isSelected) => Container(
          height: 350,
          width: 300,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: appWidgetsList[index]),
        ),
      ),
    );

    return SelectionCarousel<int>(
      title: "Apps List Widgets",
      items: carouselItems,
      initialIndex: selectedAppListIndex,
      aspectRatio: 0.85,
      viewportFraction: 0.8,
      itemHeight: 350,
      itemWidth: 300,
      onSelect: (selectedIndex) async {
        // Update selected list widget
        ref.read(selectedAppListWidgetProvider.notifier).state = selectedIndex;

        // Save the selection to SharedPreferences
        await _saveSelectedAppsListIndex(selectedIndex);
      },
    );
  }

  // Save selected list index to SharedPreferences
  Future<void> _saveSelectedAppsListIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedAppListIndex', index);
  }
}
