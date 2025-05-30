import 'package:flutter/material.dart';

class NaverLoginButton extends StatelessWidget {
  const NaverLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleNaverLogin(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF03C75A),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Color(0xFF03C75A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
          ),
          const Text(
            '네이버로 시작하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNaverLogin(BuildContext context) {
    // TODO: 네이버 로그인 로직 연동
    print('네이버 로그인 버튼 클릭됨');
  }
}
