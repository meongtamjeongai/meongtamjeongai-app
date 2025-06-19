import 'package:flutter/material.dart';

class DetectedRisksCard extends StatelessWidget {
  final String reason;

  const DetectedRisksCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final List<String> risks =
        reason
            .split(RegExp(r'[,\n]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '발견된 위험 요소',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFDEE2E6)),
          ),
          child:
              risks.isEmpty
                  ? const Text(
                    '위험 요소가 발견되지 않았어요.',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF212529),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        risks
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                ), // 간격 줄임
                                child: Text(
                                  '• $e',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFF212529),
                                    fontWeight: FontWeight.w500,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
        ),
      ],
    );
  }
}
