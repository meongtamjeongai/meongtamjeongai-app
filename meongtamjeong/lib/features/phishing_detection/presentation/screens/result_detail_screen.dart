import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/detected_risks_card.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/handling_steps_card.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/emergency_contact_card.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/result_visualization.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/risk_level_indicator.dart';

class ResultDetailScreen extends StatelessWidget {
  const ResultDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int score = Random().nextInt(101);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          '분석 결과',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // ✅ 스크롤 가능하게 만듦
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 110),
              ResultVisualization(score: score),
              const SizedBox(height: 10),
              RiskLevelIndicator(score: score),
              const SizedBox(height: 40),
              const DetectedRisksCard(),
              const SizedBox(height: 40),
              const HandlingStepsCard(),
              const EmergencyContactCard(),
              const SizedBox(height: 40), // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
