import 'package:flutter/material.dart';

class HandlingStepsCard extends StatelessWidget {
  const HandlingStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = [
      '의심 메시지를 클릭했다면 기기에 설치된 알 수 없는 앱이 있는지 확인해보세요.',
      '설정 > 보안에서 알 수 없는 앱 설치를 제한해보세요.',
      '모바일 백신 앱으로 악성 앱 여부를 검사하세요.',
      '피해 사례는 주변 지인에게도 공유해 2차 피해를 막아주세요.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '단계별 대처 방법',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 253, 255), // 밝은 회색 배경
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDEE2E6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                steps
                    .map(
                      (step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '* ',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(255, 83, 89, 95),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF212529),
                                ),
                              ),
                            ),
                          ],
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
