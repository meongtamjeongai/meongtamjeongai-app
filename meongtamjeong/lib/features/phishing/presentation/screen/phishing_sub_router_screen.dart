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
    switch (sub) {
      case 'simulation':
        return SimulationMainScreen(onBack: onBack);
      case 'guide':
        return PhishingHandlingGuideScreen(onBack: onBack);
      case 'investigation':
      default:
        return DetectionMainScreen(onBack: onBack);
    }
  }
}
