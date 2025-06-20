// // meongtamdjeong_flutter/lib/models/user_model.dart
// // 백엔드의 UserClientProfileResponse 스키마에 대응하는 모델

// // SocialAccountModel 및 UserPointModel은 이 파일에서 직접 사용하지 않으므로 임포트 제거 가능
// // 만약 login_provider 외에 상세 소셜 정보나 포인트 상세 정보가 필요하면 다시 추가

// class UserModel {
//   // 이름을 UserClientProfileModel 등으로 변경하는 것이 더 명확할 수 있음
//   final int id;
//   final String? email;
//   final String? username;
//   final bool isGuest;
//   final String? loginProvider; // 백엔드에서 오는 'login_provider' 필드
//   final int points; // 백엔드에서 오는 'points' 필드 (또는 'current_points')

//   UserModel({
//     required this.id,
//     this.email,
//     this.username,
//     required this.isGuest,
//     this.loginProvider,
//     required this.points,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     print("UserModel.fromJson input: $json"); // 수신된 JSON 직접 확인
//     return UserModel(
//       id: json['id'] as int,
//       email: json['email'] as String?,
//       username: json['username'] as String?,
//       isGuest: json['is_guest'] as bool? ?? false, // is_guest는 항상 올 것으로 예상
//       loginProvider: json['login_provider'] as String?,
//       // 백엔드 UserClientProfileResponse 스키마의 computed_field 이름이 'points'인지 'current_points'인지 확인 필요
//       // 이전 스키마에서는 'points'로 최종 필드명을 사용했음.
//       points: json['points'] as int? ?? 0,
//     );
//   }

//   // toJson은 현재 클라이언트에서 서버로 User 정보를 보낼 일이 없으므로 단순하게 유지하거나 제거 가능
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'username': username,
//       'is_guest': isGuest,
//       'login_provider': loginProvider,
//       'points': points,
//     };
//   }
// }
import 'user_point_model.dart';

class UserModel {
  final int id;
  final String? email;
  final String? username;
  final bool isGuest;
  final String? loginProvider;
  final int points;

  // ✅ 추가된 필드
  final String? profileImageKey;
  final UserPointModel? userPoint;

  UserModel({
    required this.id,
    this.email,
    this.username,
    required this.isGuest,
    this.loginProvider,
    required this.points,
    this.profileImageKey,
    this.userPoint,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("UserModel.fromJson input: $json");
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String?,
      username: json['username'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
      loginProvider: json['login_provider'] as String?,
      points: json['points'] as int? ?? 0,
      profileImageKey: json['profile_image_key'] as String?,
      userPoint:
          json['user_point'] != null
              ? UserPointModel.fromJson(json['user_point'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'is_guest': isGuest,
      'login_provider': loginProvider,
      'points': points,
      'profile_image_key': profileImageKey,
      'user_point': userPoint?.toJson(),
    };
  }
}
