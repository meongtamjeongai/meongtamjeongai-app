import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class KakaoLoginButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onStartLogin;
  final VoidCallback? onFinishLogin;
  final VoidCallback? onLoginSuccess;

  const KakaoLoginButton({
    super.key,
    required this.isEnabled,
    required this.onStartLogin,
    this.onFinishLogin,
    this.onLoginSuccess,
  });

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  String _status = '카카오 로그인';

  final String _serverBase = 'https://meong.shop';

  Future<void> _loginWithKakao() async {
    if (!widget.isEnabled) return;

    widget.onStartLogin();

    try {
      developer.log('▶️ _loginWithKakao 시작');

      final token = await UserApi.instance.loginWithKakaoTalk();
      developer.log('✅ 카카오톡 로그인 성공: $token');

      final kakaoToken = token.accessToken;

      final kakaoResp = await http.post(
        Uri.parse('$_serverBase/api/v1/social/kakao/token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'access_token': kakaoToken}),
      );
      developer.log('▶ 서버 응답 코드: ${kakaoResp.statusCode}');
      developer.log('▶ 서버 응답 바디: ${kakaoResp.body}');

      if (!mounted) return;
      if (kakaoResp.statusCode == 200) {
        setState(() {
          _status = '카카오 서버 인증 성공';
        });
        widget.onLoginSuccess?.call();
      } else {
        setState(() {
          _status = '카카오 서버 인증 실패';
        });
      }

      final user = await UserApi.instance.me();
      final nickname = user.kakaoAccount?.profile?.nickname ?? '사용자';
      if (!mounted) return;
      setState(() => _status = '카카오: $nickname');
    } catch (e) {
      developer.log('⚠️ 카카오 로그인 에러: $e');
      if (!mounted) return;
      setState(() {
        _status = '카카오 로그인 에러';
      });
    } finally {
      widget.onFinishLogin?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? _loginWithKakao : null,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icons/kakao.png',
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            // Text(_status, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
