// meongtamdjeong_flutter/lib/models/token_model.dart
// 백엔드로부터 받는 JWT 토큰 정보를 담는 모델

class Token {
  final String accessToken;
  final String? refreshToken; // 리프레시 토큰은 선택적일 수 있음
  final String tokenType;

  Token({
    required this.accessToken,
    this.refreshToken,
    this.tokenType = "bearer",
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
    };
  }
}
