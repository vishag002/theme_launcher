import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_launcher/controller/time_controller.dart';
import 'package:theme_launcher/widgets/clock%20widgets/clock_widget_1.dart';

final selectedClockWidgetProvider = StateProvider<int>((ref) => 0);

// Provider for the list of clock widgets
final clockWidgetListProvider = Provider((ref) => [
      ClockWidget1(timerModel: ref.watch(timerControllerProvider)),
      ClockWidget2(timerModel: ref.watch(timerControllerProvider)),
      ClockWidget3(timerModel: ref.watch(timerControllerProvider)),
      ClockWidget4(timerModel: ref.watch(timerControllerProvider)),
      ClockWidget5(timerModel: ref.watch(timerControllerProvider)),
    ]);
