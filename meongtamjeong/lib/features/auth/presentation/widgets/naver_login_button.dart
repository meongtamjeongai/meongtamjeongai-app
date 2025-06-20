import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class NaverLoginButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onStartLogin;
  final VoidCallback? onFinishLogin;
  final VoidCallback? onLoginSuccess;

  const NaverLoginButton({
    super.key,
    required this.isEnabled,
    required this.onStartLogin,
    this.onFinishLogin,
    this.onLoginSuccess,
  });

  @override
  State<NaverLoginButton> createState() => _NaverLoginButtonState();
}

class _NaverLoginButtonState extends State<NaverLoginButton> {
  String _status = '네이버 로그인';

  final String _serverBase = 'https://meong.shop';

  Future<void> _loginWithNaver() async {
    if (!widget.isEnabled) return;

    widget.onStartLogin();

    try {
      developer.log('▶️ _loginWithNaver 시작');

      final result = await FlutterNaverLogin.logIn();
      developer.log(
        '✅ FlutterNaverLogin result: ${result.status}, ${result.account}',
      );

      if (result.status == NaverLoginStatus.loggedIn) {
        final token = await FlutterNaverLogin.getCurrentAccessToken();
        final naverToken = token.accessToken;

        developer.log('▶️ 네이버 토큰 획득: $naverToken');
        developer.log('▶️ 서버로 토큰 전송 시작');

        final naverResp = await http.post(
          Uri.parse('$_serverBase/api/v1/social/naver/token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'access_token': naverToken}),
        );

        developer.log('▶ 서버 응답 상태코드: ${naverResp.statusCode}');
        developer.log('▶ 서버 응답 바디: ${naverResp.body}');

        if (!mounted) return;
        if (naverResp.statusCode == 200) {
          setState(() {
            _status = '네이버 서버 인증 성공';
          });
          widget.onLoginSuccess?.call();
        } else {
          setState(() {
            _status = '네이버 서버 인증 실패';
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _status = '네이버 로그인 실패: ${result.status}';
        });
      }
    } catch (e, st) {
      developer.log('❌ 네이버 로그인 에러', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() {
        _status = '네이버 로그인 에러: $e';
      });
    } finally {
      widget.onFinishLogin?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? _loginWithNaver : null,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icons/naver.png',
              width: double.infinity,
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
