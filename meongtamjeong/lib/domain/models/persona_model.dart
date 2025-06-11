// meongtamdjeong_flutter/lib/models/persona_model.dart
// 백엔드로부터 받는 페르소나 정보를 담는 모델 (PersonaResponse 대응)

class PersonaModel {
  final int id;
  final String name;
  final String? description;
  final String? profileImageUrl; // Pydantic의 HttpUrl은 Dart에서 String으로 받음
  final String systemPrompt;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdByUserId;
  // final PersonaCreatorInfoModel? creator; // PersonaCreatorInfo 스키마에 대응하는 모델 (필요시 추가)

  PersonaModel({
    required this.id,
    required this.name,
    this.description,
    this.profileImageUrl,
    required this.systemPrompt,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    this.createdByUserId,
    // this.creator,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      systemPrompt: json['system_prompt'] as String,
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdByUserId: json['created_by_user_id'] as int?,
      // creator: json['creator'] != null
      //   ? PersonaCreatorInfoModel.fromJson(json['creator'] as Map<String, dynamic>)
      //   : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profile_image_url': profileImageUrl,
      'system_prompt': systemPrompt,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by_user_id': createdByUserId,
      // 'creator': creator?.toJson(),
    };
  }
}

// // 필요시 PersonaCreatorInfo 모델 (백엔드 스키마 PersonaCreatorInfo 대응)
// class PersonaCreatorInfoModel {
//   final int id;
//   final String? username;
//   final String? email;

//   PersonaCreatorInfoModel({required this.id, this.username, this.email});

//   factory PersonaCreatorInfoModel.fromJson(Map<String, dynamic> json) {
//     return PersonaCreatorInfoModel(
//       id: json['id'] as int,
//       username: json['username'] as String?,
//       email: json['email'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//     };
//   }
// }
