import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestBrowseButton extends StatelessWidget {
  const GuestBrowseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: 비회원 상태로 홈 또는 캐릭터 선택으로 이동
        context.go('/character-select');
      },
      child: const Text(
        '로그인 없이 둘러보기',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
