// meongtamdjeong_flutter/lib/models/message_model.dart
// 백엔드로부터 받는 메시지 정보를 담는 모델 (MessageResponse 대응)

// 백엔드의 SenderType Enum에 맞춰 Dart Enum 정의
enum SenderType {
  user,
  ai,
  system;

  // JSON 문자열로부터 Enum 값을 생성하는 factory constructor
  factory SenderType.fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'user':
        return SenderType.user;
      case 'ai':
        return SenderType.ai;
      case 'system':
        return SenderType.system;
      default:
        // 알 수 없는 값에 대한 기본 처리 또는 예외 발생
        print("Warning: Unknown SenderType '$value', defaulting to system.");
        return SenderType.system;
    }
  }

  // Enum 값을 JSON 문자열로 변환
  String toJson() {
    return name; // Dart 2.15+ 에서는 name getter 사용 가능
    // 이전 버전: return toString().split('.').last;
  }
}

class MessageModel {
  final int id;
  final int conversationId;
  final SenderType senderType;
  final String content;
  final int? geminiTokenUsage;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.content,
    this.geminiTokenUsage,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      senderType: SenderType.fromJson(json['sender_type'] as String),
      content: json['content'] as String,
      geminiTokenUsage: json['gemini_token_usage'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_type': senderType.toJson(),
      'content': content,
      'gemini_token_usage': geminiTokenUsage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
