// meongtamdjeong_flutter/lib/models/social_account_model.dart
// 백엔드로부터 받는 소셜 계정 정보를 담는 모델

// 백엔드의 SocialProvider Enum과 동일하게 정의
enum SocialProvider {
  firebase_google,
  firebase_anonymous,
  guest; // NAVER, KAKAO 등 추후 추가 가능

  factory SocialProvider.fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'firebase_google':
        return SocialProvider.firebase_google;
      case 'firebase_anonymous':
        return SocialProvider.firebase_anonymous;
      case 'guest':
        return SocialProvider.guest;
      default:
        print("Warning: Unknown SocialProvider '$value', defaulting to guest.");
        return SocialProvider.guest;
    }
  }

  String toJson() {
    return name;
  }
}

class SocialAccountModel {
  final int id;
  final int userId;
  final SocialProvider provider;
  final String providerUserId;
  final DateTime createdAt;

  SocialAccountModel({
    required this.id,
    required this.userId,
    required this.provider,
    required this.providerUserId,
    required this.createdAt,
  });

  factory SocialAccountModel.fromJson(Map<String, dynamic> json) {
    return SocialAccountModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      provider: SocialProvider.fromJson(json['provider'] as String),
      providerUserId: json['provider_user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider.toJson(),
      'provider_user_id': providerUserId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
