import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h1 = MediaQuery.of(context).size.height;
    final w1 = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: h1 * .2,
            width: w1,
            //color: Colors.amber,
            child: Center(child: Text("10:50 AM")),
          ),
        ],
      ),
    );
  }
}
