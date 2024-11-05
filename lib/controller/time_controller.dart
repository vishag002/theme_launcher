// timer_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:theme_launcher/models/timer_class.dart';

class TimerController extends StateNotifier<TimerModel> {
  TimerController() : super(TimerModel()) {
    _startTimer();
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      state = TimerModel(
        date: now,
        weekDay: _getWeekDay(now.weekday),
        month: _getMonth(now.month),
        period: now.hour >= 12 ? 'PM' : 'AM',
        hour: _formatHour(now.hour),
        minutes: now.minute.toString().padLeft(2, '0'),
        seconds: now.second.toString().padLeft(2, '0'),
      );
    });
  }

  String _getWeekDay(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _formatHour(int hour) {
    final formattedHour = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    return formattedHour.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Providers
final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerModel>((ref) {
  return TimerController();
});
