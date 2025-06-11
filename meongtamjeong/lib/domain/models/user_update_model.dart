// meongtamdjeong_flutter/lib/models/user_update_model.dart
// 사용자 정보 수정을 위한 데이터 모델 (부분 업데이트 지원)

class UserUpdateModel {
  final String? username;
  final String? email;
  final String? password;
  // is_active, is_superuser 등 관리자만 변경 가능한 필드는 제외

  UserUpdateModel({this.username, this.email, this.password});

  // null이 아닌 필드만 포함하여 부분 업데이트를 지원
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null && username!.isNotEmpty) {
      data['username'] = username;
    }
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    return data;
  }
}
