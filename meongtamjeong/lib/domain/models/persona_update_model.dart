// meongtamdjeong_flutter/lib/models/persona_update_model.dart
// 페르소나 정보 수정을 위한 데이터 모델 (부분 업데이트 지원)

class PersonaUpdateModel {
  final String? name;
  final String? description;
  final String? profileImageUrl;
  final String? systemPrompt;
  final bool? isPublic;

  PersonaUpdateModel({
    this.name,
    this.description,
    this.profileImageUrl,
    this.systemPrompt,
    this.isPublic,
  });

  /// toJson 메서드는 null이 아닌 필드만 포함하는 Map을 생성합니다.
  /// 이렇게 하면 FastAPI 백엔드의 Pydantic 모델이 `exclude_unset=True` 옵션과 함께
  /// 전달된 필드만 인식하여 부분 업데이트를 수행할 수 있습니다.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // 필드 값이 null이 아닐 때만 Map에 추가
    if (name != null) {
      data['name'] = name;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (profileImageUrl != null) {
      data['profile_image_url'] = profileImageUrl;
    }
    if (systemPrompt != null) {
      data['system_prompt'] = systemPrompt;
    }
    if (isPublic != null) {
      data['is_public'] = isPublic;
    }

    return data;
  }
}
