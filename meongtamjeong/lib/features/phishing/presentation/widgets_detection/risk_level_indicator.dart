import 'package:flutter/material.dart';

class RiskLevelIndicator extends StatelessWidget {
  final int score;

  const RiskLevelIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final String label = _riskLabel(score);
    final Color bgColor = _riskColor(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 수평 가운데
        crossAxisAlignment: CrossAxisAlignment.center, // 수직 가운데
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.yellow,
            size: 28,
          ),
          const SizedBox(width: 5),
          const Text(
            '피싱의심 확률: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            _riskLabel(score),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static String _riskLabel(int score) {
    if (score < 20) return '낮음';
    if (score < 60) return '위험';
    return '높음';
  }

  static Color _riskColor(int score) {
    if (score < 20) return const Color.fromARGB(255, 80, 190, 84); // 쨍한 초록
    if (score < 60) return const Color.fromARGB(255, 243, 146, 1); // 쨍한 주황
    return const Color(0xFFF44336); // 쨍한 빨강
  }
}
