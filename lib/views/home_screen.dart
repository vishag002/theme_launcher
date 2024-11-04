import 'package:flutter/material.dart';
import 'package:theme_launcher/controller/time_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h1 = MediaQuery.of(context).size.height;
    final w1 = MediaQuery.of(context).size.width;

    return GestureDetector(
      //todo:
      // onVerticalDragEnd: (details) async {
      //   if (details.primaryVelocity! > 0) {
      //     print(
      //         "Vertical drag ended: Drag down detected, opening notification panel.");
      //     try {
      //       await NotificationPanelService.openNotificationPanel();
      //     } catch (e) {
      //       print("Error opening notification panel: $e");
      //     }
      //   } else {
      //     print(
      //         "Vertical drag ended: No significant vertical movement detected.");
      //   }
      // },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: h1 * 0.2,
              width: w1,
              child: Center(
                child: TimerWidget(
                  style: TimerStyle.minimal,
                  fontSize: 40,
                  textColor: Theme.of(context).colorScheme.secondary,
                  showSeconds: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
