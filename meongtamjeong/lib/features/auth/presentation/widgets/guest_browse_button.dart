import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestBrowseButton extends StatelessWidget {
  const GuestBrowseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        print('--------------로그인없이---------');
        context.go('/character-select');
      },
      child: const Text(
        '로그인 없이 둘러보기',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
