import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockWidgetScreen extends ConsumerWidget {
  const ClockWidgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clock widgets"),
      ),
    );
  }
}
