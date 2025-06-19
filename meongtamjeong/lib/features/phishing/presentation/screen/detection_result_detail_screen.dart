import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/phishing_analysis_result.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/detected_risks_card.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/emergency_contact_card.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/result_visualization.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/risk_level_indicator.dart';

class ResultDetailScreen extends StatelessWidget {
  final PhishingAnalysisResult result;

  const ResultDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int score = result.phishingScore;

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
              DetectedRisksCard(reason: result.reason), // ✅ reason 전달 (옵션)
              const SizedBox(height: 10),
              const EmergencyContactCard(),
            ],
          ),
        ),
      ),
    );
  }
}
