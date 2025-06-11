// meongtamdjeong_flutter/lib/models/user_point_model.dart
// 백엔드로부터 받는 사용자 포인트 정보를 담는 모델

class UserPointModel {
  final int userId;
  final int points;
  final DateTime lastUpdatedAt;

  UserPointModel({
    required this.userId,
    required this.points,
    required this.lastUpdatedAt,
  });

  factory UserPointModel.fromJson(Map<String, dynamic> json) {
    return UserPointModel(
      userId: json['user_id'] as int,
      points: json['points'] as int,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'points': points,
      'last_updated_at': lastUpdatedAt.toIso8601String(),
    };
  }
}
