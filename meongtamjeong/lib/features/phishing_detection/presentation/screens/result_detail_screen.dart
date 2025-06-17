import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/emergency_contact_card.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/result_visualization.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/risk_level_indicator.dart';

class ResultDetailScreen extends StatelessWidget {
  const ResultDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int score = Random().nextInt(101); // ✅ 0~100 사이 랜덤 점수 생성

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // 파란 계열 배경
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          '분석 결과',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResultVisualization(score: score),
            const SizedBox(height: 24),
            RiskLevelIndicator(score: score),
            const SizedBox(height: 28),
            const Text(
              '🛠️ 발견된 위험 요소',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '- 짧은 링크 URL 사용\n- 사칭된 기관명 포함\n- 과도한 긴급성 표현',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            const Text(
              '📋 단계별 대처 방법',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. 해당 메시지를 클릭하지 마세요.\n'
              '2. 출처가 확실한 경로로 문의하세요.\n'
              '3. 이미 클릭했다면 백신 검사 또는 보안 점검을 권장합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            const EmergencyContactCard(), // 사이버 경찰청 연락처 포함
          ],
        ),
      ),
    );
  }
}
