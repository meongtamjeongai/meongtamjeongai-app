// lib/features/phishing/presentation/screen/phishing_sub_router_screen.dart
import 'package:flutter/material.dart';
import 'detection_main_screen.dart';
import 'simulation_main_screen.dart';
import 'phishing_handling_guide_main_screen.dart';

class PhishingSubRouterScreen extends StatelessWidget {
  final String sub;
  final VoidCallback onBack;

  const PhishingSubRouterScreen({
    super.key,
    required this.sub,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (sub) {
      case 'simulation':
        screen = const PhishingSimulationScreen();
        break;
      case 'guide':
        screen = const PhishingHandlingGuideScreen();
        break;
      case 'investigation':
      default:
        screen = const DetectionMainScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("피싱 기능"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: screen,
    );
  }
}
