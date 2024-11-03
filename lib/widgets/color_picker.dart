import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:theme_launcher/provider/color_scheme_provider.dart';

final primaryColorProvider = StateProvider<Color>((ref) => Colors.white);
final secondaryColorProvider = StateProvider<Color>((ref) => Colors.black);

class ColorPickerScreen extends ConsumerWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(primaryColorProvider);
    final secondaryColor = ref.watch(secondaryColorProvider);

    // // Update theme whenever colors change
    // ref.listen(primaryColorProvider, (previous, next) {
    //   ref.read(themeProvider.notifier).updateTheme(
    //         next,
    //         ref.read(secondaryColorProvider),
    //       );
    // });

    // ref.listen(secondaryColorProvider, (previous, next) {
    //   ref.read(themeProvider.notifier).updateTheme(
    //         ref.read(primaryColorProvider),
    //         next,
    //       );
    // });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Color Picker Screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Primary color"),
            subtitle: const Text("Changes app background color"),
            trailing: CircleAvatar(backgroundColor: primaryColor),
            onTap: () => _showColorPickerDialog(context, ref, isPrimary: true),
          ),
          ListTile(
            title: const Text("Secondary color"),
            subtitle: const Text("Changes text color"),
            trailing: CircleAvatar(backgroundColor: secondaryColor),
            onTap: () => _showColorPickerDialog(context, ref, isPrimary: false),
          ),
          // Example widgets to show theme application
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme Preview",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Text(
                  "This is a sample text to preview the selected colors",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Another text with different size",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, WidgetRef ref,
      {required bool isPrimary}) {
    final initialColor = isPrimary
        ? ref.read(primaryColorProvider)
        : ref.read(secondaryColorProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              isPrimary ? 'Pick a Primary Color!' : 'Pick a Secondary Color!'),
          content: SingleChildScrollView(
            child: HueRingPicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                ref
                    .read(isPrimary
                        ? primaryColorProvider.notifier
                        : secondaryColorProvider.notifier)
                    .state = color;
              },
              pickerAreaBorderRadius: BorderRadius.circular(10),
              displayThumbColor: true,
              enableAlpha: true,
              portraitOnly: false,
              hueRingStrokeWidth: 15,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
