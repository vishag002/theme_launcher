// timer_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class TimerController extends StateNotifier<DateTime> {
  TimerController() : super(DateTime.now()) {
    _startTimer();
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Providers
final timerControllerProvider =
    StateNotifierProvider<TimerController, DateTime>((ref) {
  return TimerController();
});

final hourProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  final hour = now.hour > 12
      ? now.hour - 12
      : now.hour == 0
          ? 12
          : now.hour;
  return hour.toString().padLeft(2, '0');
});

final minuteProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  return now.minute.toString().padLeft(2, '0');
});

final secondProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  return now.second.toString().padLeft(2, '0');
});

final periodProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  return now.hour >= 12 ? 'PM' : 'AM';
});

final weekdayProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  final weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return weekdays[now.weekday - 1];
});

final monthProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  final months = [
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
  return months[now.month - 1];
});

final dateProvider = Provider<String>((ref) {
  final now = ref.watch(timerControllerProvider);
  return now.day.toString();
});

enum TimerStyle { digital, minimal, classic, modern }

class TimerWidget extends ConsumerWidget {
  final TimerStyle style;
  final Color? textColor;
  final double? fontSize;
  final bool showSeconds;
  final bool showDate;

  const TimerWidget({
    super.key,
    this.style = TimerStyle.digital,
    this.textColor,
    this.fontSize,
    this.showSeconds = true,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = ref.watch(hourProvider);
    final minute = ref.watch(minuteProvider);
    final second = ref.watch(secondProvider);
    final period = ref.watch(periodProvider);
    final weekday = ref.watch(weekdayProvider);
    final month = ref.watch(monthProvider);
    final date = ref.watch(dateProvider);

    switch (style) {
      case TimerStyle.digital:
        return DigitalTimerStyle(
          hour: hour,
          minute: minute,
          second: second,
          period: period,
          weekday: weekday,
          month: month,
          date: date,
          textColor: textColor,
          fontSize: fontSize,
          showSeconds: showSeconds,
          showDate: showDate,
        );

      case TimerStyle.minimal:
        return MinimalTimerStyle(
          hour: hour,
          minute: minute,
          period: period,
          textColor: textColor,
          fontSize: fontSize,
        );

      case TimerStyle.classic:
        return ClassicTimerStyle(
          hour: hour,
          minute: minute,
          second: second,
          period: period,
          weekday: weekday,
          month: month,
          date: date,
          textColor: textColor,
          fontSize: fontSize,
          showSeconds: showSeconds,
          showDate: showDate,
        );

      case TimerStyle.modern:
        return ModernTimerStyle(
          hour: hour,
          minute: minute,
          second: second,
          period: period,
          weekday: weekday,
          month: month,
          date: date,
          textColor: textColor,
          fontSize: fontSize,
          showSeconds: showSeconds,
          showDate: showDate,
        );
    }
  }
}

// Timer Styles
class DigitalTimerStyle extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;
  final String period;
  final String weekday;
  final String month;
  final String date;
  final Color? textColor;
  final double? fontSize;
  final bool showSeconds;
  final bool showDate;

  const DigitalTimerStyle({
    super.key,
    required this.hour,
    required this.minute,
    required this.second,
    required this.period,
    required this.weekday,
    required this.month,
    required this.date,
    this.textColor,
    this.fontSize,
    this.showSeconds = true,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$hour:$minute${showSeconds ? ':$second' : ''}',
              style: TextStyle(
                fontSize: fontSize ?? 40,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(width: 8),
            Text(
              period,
              style: TextStyle(
                fontSize: (fontSize ?? 40) * 0.5,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.black,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
        if (showDate) ...[
          const SizedBox(height: 8),
          Text(
            '$weekday, $month $date',
            style: TextStyle(
              fontSize: (fontSize ?? 40) * 0.4,
              color: textColor?.withOpacity(0.7) ?? Colors.black54,
              fontFamily: 'Courier',
            ),
          ),
        ],
      ],
    );
  }
}

class MinimalTimerStyle extends StatelessWidget {
  final String hour;
  final String minute;
  final String period;
  final Color? textColor;
  final double? fontSize;

  const MinimalTimerStyle({
    super.key,
    required this.hour,
    required this.minute,
    required this.period,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$hour:$minute',
          style: TextStyle(
            fontSize: fontSize ?? 32,
            color: textColor ?? Colors.black87,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          period,
          style: TextStyle(
            fontSize: (fontSize ?? 32) * 0.6,
            color: textColor?.withOpacity(0.7) ?? Colors.black54,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class ClassicTimerStyle extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;
  final String period;
  final String weekday;
  final String month;
  final String date;
  final Color? textColor;
  final double? fontSize;
  final bool showSeconds;
  final bool showDate;

  const ClassicTimerStyle({
    super.key,
    required this.hour,
    required this.minute,
    required this.second,
    required this.period,
    required this.weekday,
    required this.month,
    required this.date,
    this.textColor,
    this.fontSize,
    this.showSeconds = true,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: textColor?.withOpacity(0.3) ?? Colors.black26,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$hour:$minute${showSeconds ? ':$second' : ''} $period',
                style: TextStyle(
                  fontSize: fontSize ?? 36,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        if (showDate) ...[
          const SizedBox(height: 8),
          Text(
            '$weekday, $month $date',
            style: TextStyle(
              fontSize: (fontSize ?? 36) * 0.4,
              color: textColor?.withOpacity(0.7) ?? Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

class ModernTimerStyle extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;
  final String period;
  final String weekday;
  final String month;
  final String date;
  final Color? textColor;
  final double? fontSize;
  final bool showSeconds;
  final bool showDate;

  const ModernTimerStyle({
    super.key,
    required this.hour,
    required this.minute,
    required this.second,
    required this.period,
    required this.weekday,
    required this.month,
    required this.date,
    this.textColor,
    this.fontSize,
    this.showSeconds = true,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = textColor ?? Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(0.05),
            baseColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                hour,
                style: TextStyle(
                  fontSize: fontSize ?? 48,
                  fontWeight: FontWeight.w600,
                  color: baseColor,
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                  fontSize: fontSize ?? 48,
                  fontWeight: FontWeight.w300,
                  color: baseColor.withOpacity(0.5),
                ),
              ),
              Text(
                minute,
                style: TextStyle(
                  fontSize: fontSize ?? 48,
                  fontWeight: FontWeight.w600,
                  color: baseColor,
                ),
              ),
              if (showSeconds) ...[
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: fontSize ?? 48,
                    fontWeight: FontWeight.w300,
                    color: baseColor.withOpacity(0.5),
                  ),
                ),
                Text(
                  second,
                  style: TextStyle(
                    fontSize: fontSize ?? 48,
                    fontWeight: FontWeight.w600,
                    color: baseColor,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                period,
                style: TextStyle(
                  fontSize: (fontSize ?? 48) * 0.4,
                  fontWeight: FontWeight.w500,
                  color: baseColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          if (showDate) ...[
            const SizedBox(height: 8),
            Text(
              '$weekday, $month $date',
              style: TextStyle(
                fontSize: (fontSize ?? 48) * 0.3,
                fontWeight: FontWeight.w400,
                color: baseColor.withOpacity(0.6),
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
