import 'package:flutter/material.dart';

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFFF3B30); // 쨍한 분홍 테두리

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white, // 배경 흰색
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 250, 153, 148),
          width: 2,
        ), // 테두리 강조
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.phone_in_talk, color: borderColor, size: 28), // 분홍색 아이콘
          SizedBox(width: 12),
          Text(
            '사이버범죄 신고는 경찰청 182로 전화하세요!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87, // 검정 텍스트
            ),
          ),
        ],
      ),
    );
  }
}
