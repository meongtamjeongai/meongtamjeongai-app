import 'package:flutter/material.dart';

class HandlingStepsCard extends StatelessWidget {
  const HandlingStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📌 단계별 대처 방법',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('1. 의심 메시지는 절대 클릭하지 마세요.'),
          Text('2. 발신자 정보를 확인하고 차단하세요.'),
          Text('3. 관련 기관에 신고하세요 (예: 경찰청 182).'),
        ],
      ),
    );
  }
}
