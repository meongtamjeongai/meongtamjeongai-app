import 'package:flutter/material.dart';

class SafetyGuideCard extends StatelessWidget {
  const SafetyGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tips = [
      {
        'icon': Icons.warning_amber_outlined,
        'text': '의심스러운 메시지는 절대 클릭하지 마세요.',
        'highlight': true,
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'text': '메세지나 이메일을 캡쳐해서 보여주세요.',
        'highlight': true,
      },
      {
        'icon': Icons.record_voice_over,
        'text': '개인정보(주민번호, 계좌번호 등)는 공유하지 마세요.',
      },
      {'icon': Icons.email_outlined, 'text': '공식 기관도 이메일로 비밀번호를 요구하지 않습니다.'},
      {'icon': Icons.contact_support_outlined, 'text': '멍탐정이 피싱예방을 도와드릴게요.'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        // color: const Color(0xFFF0F4FA),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '피싱 조사 팁',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) {
            final isHighlight = tip['highlight'] == true;
            final icon = tip['icon'] as IconData;
            final text = tip['text'] as String;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isHighlight ? Colors.red : Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
