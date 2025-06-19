import 'package:flutter/material.dart';

class DetectedRisksCard extends StatelessWidget {
  const DetectedRisksCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> risks = ['짧은 링크 URL 사용', '사칭된 기관명 포함', '과도한 긴급성 표현'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 제목 왼쪽 정렬
      children: [
        const Text(
          '발견된 위험 요소',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              risks.map((risk) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 40 - 12) / 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        240,
                        242,
                        244,
                      ), // 밝고 세련된 연그레이
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDEE2E6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.02,
                          ), // 그림자 색 (살짝 어두운 회색)
                          blurRadius: 3, // 흐림 정도
                          offset: const Offset(0, 3), // 위치 (x, y)
                        ),
                      ],
                    ),
                    child: Text(
                      risk,
                      textAlign: TextAlign.center, // ✅ 박스 안 텍스트는 가운데 정렬
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF212529),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
