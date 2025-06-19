import 'package:flutter/material.dart';

class PhishingSimulationScreen extends StatelessWidget {
  const PhishingSimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('피싱시뮬레이션')),
      body: Center(child: Text('시뮬레이션')),
    );
  }
}
