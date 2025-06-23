// meongtamdjeong_flutter/lib/models/persona_model.dart

class PersonaModel {
  final int id;
  final String name;
  final String? description;
  String? profileImageUrl;
  final String? profileImageKey;
  final String systemPrompt;
  final String? startingMessage; // ✅ 추가됨
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdByUserId;

  PersonaModel({
    required this.id,
    required this.name,
    this.description,
    this.profileImageUrl,
    this.profileImageKey,
    required this.systemPrompt,
    this.startingMessage, // ✅ 추가됨
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    this.createdByUserId,
  });

  PersonaModel copyWith({
    int? id,
    String? name,
    String? description,
    String? profileImageUrl,
    String? profileImageKey,
    String? systemPrompt,
    String? startingMessage, // ✅ 추가됨
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdByUserId,
  }) {
    return PersonaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageKey: profileImageKey ?? this.profileImageKey,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      startingMessage: startingMessage ?? this.startingMessage, // ✅ 추가됨
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
    );
  }

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      profileImageKey: json['profile_image_key'] as String?,
      systemPrompt: json['system_prompt'] as String,
      startingMessage: json['starting_message'] as String?, // ✅ 파싱 추가됨
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdByUserId: json['created_by_user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profile_image_url': profileImageUrl,
      'profile_image_key': profileImageKey,
      'system_prompt': systemPrompt,
      'starting_message': startingMessage, // ✅ 추가됨
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by_user_id': createdByUserId,
    };
  }
}
