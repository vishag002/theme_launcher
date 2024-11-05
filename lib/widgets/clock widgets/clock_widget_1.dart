import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_launcher/models/timer_class.dart';

class ClockWidget1 extends ConsumerWidget {
  final TimerModel timerModel;

  const ClockWidget1({super.key, required this.timerModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              timerModel.weekDay ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timerModel.hour ?? "",
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            leading: Text(
              timerModel.month ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class ClockWidget2 extends ConsumerWidget {
  final TimerModel timerModel;

  const ClockWidget2({super.key, required this.timerModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            timerModel.date?.toLocal().toString().split(' ')[0] ?? 'No Date',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            timerModel.weekDay ?? "",
            style: const TextStyle(fontSize: 18, color: Colors.purple),
          ),
          Text(
            timerModel.hour ?? "",
            style: const TextStyle(fontSize: 24, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class ClockWidget3 extends ConsumerWidget {
  final TimerModel timerModel;

  const ClockWidget3({super.key, required this.timerModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            timerModel.month ?? "",
            style: const TextStyle(fontSize: 20, color: Colors.orange),
          ),
          Text(
            timerModel.weekDay ?? "",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            timerModel.hour ?? "",
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class ClockWidget4 extends ConsumerWidget {
  final TimerModel timerModel;

  const ClockWidget4({super.key, required this.timerModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(
          timerModel.date?.toLocal().toString().split(' ')[0] ?? "No Date",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timerModel.weekDay ?? "",
              style: const TextStyle(fontSize: 18, color: Colors.purple),
            ),
            Text(
              "Time: ${timerModel.hour ?? ""}:${timerModel.minutes ?? ""}:${timerModel.seconds ?? ""}",
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
        trailing: const Icon(Icons.access_time, color: Colors.blue),
      ),
    );
  }
}

class ClockWidget5 extends ConsumerWidget {
  final TimerModel timerModel;

  const ClockWidget5({super.key, required this.timerModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                timerModel.weekDay ?? "",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "${timerModel.month ?? ""} ${timerModel.date?.day ?? ""}, ${timerModel.date?.year ?? ""}",
                style: const TextStyle(fontSize: 20, color: Colors.teal),
              ),
              Text(
                "Current Time: ${timerModel.hour ?? ""}:${timerModel.minutes ?? ""}",
                style: const TextStyle(fontSize: 22, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
