import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFFF3B30); // 쨍한 분홍 테두리

    return GestureDetector(
      onTap: () {
        context.go(
          '/main',
          extra: {
            'index': 1, // 피싱탭
            'sub': 'guide',
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color.fromARGB(255, 250, 153, 148),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.touch_app, color: borderColor, size: 28), // 보안 느낌 아이콘
            SizedBox(width: 12),
            Flexible(
              child: Text(
                '자세한 대응법은 이곳에서 확인하세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
