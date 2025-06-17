import 'package:flutter/material.dart';

class RiskLevelIndicator extends StatelessWidget {
  final int score;

  const RiskLevelIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final String label = _riskLabel(score);
    final Color color = _riskColor(score);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 30),
          const SizedBox(width: 12),
          Text(
            '위험 수준: $label',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _riskLabel(int score) {
    if (score < 30) return '낮음';
    if (score < 70) return '중간';
    return '높음';
  }

  Color _riskColor(int score) {
    if (score < 30) return Colors.green;
    if (score < 70) return Colors.orange;
    return Colors.red;
  }
}
