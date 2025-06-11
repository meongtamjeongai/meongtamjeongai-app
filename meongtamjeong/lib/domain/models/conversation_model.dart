// meongtamdjeong_flutter/lib/models/conversation_model.dart
// 백엔드로부터 받는 대화방 정보를 담는 모델 (ConversationResponse 대응)

import 'package:meongtamjeong/domain/models/persona_model.dart';

class ConversationModel {
  final int id;
  final int userId;
  final String? title; // 대화방 제목 (선택 사항)
  final PersonaModel persona; // 대화 상대 페르소나 정보
  final DateTime createdAt;
  final DateTime lastMessageAt;
  // final ConversationLastMessageSummaryModel? lastMessageSummary; // 필요시 추가

  ConversationModel({
    required this.id,
    required this.userId,
    this.title,
    required this.persona,
    required this.createdAt,
    required this.lastMessageAt,
    // this.lastMessageSummary,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String?,
      persona: PersonaModel.fromJson(json['persona'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      // lastMessageSummary: json['last_message_summary'] != null
      //   ? ConversationLastMessageSummaryModel.fromJson(json['last_message_summary'] as Map<String, dynamic>)
      //   : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'persona': persona.toJson(), // PersonaModel의 toJson 호출
      'created_at': createdAt.toIso8601String(),
      'last_message_at': lastMessageAt.toIso8601String(),
      // 'last_message_summary': lastMessageSummary?.toJson(),
    };
  }
}

// // 필요시 ConversationLastMessageSummary 모델 (백엔드 스키마 ConversationLastMessageSummary 대응)
// class ConversationLastMessageSummaryModel {
//   final String content;
//   final String senderType; // 또는 SenderType Enum
//   final DateTime createdAt;
//
//   ConversationLastMessageSummaryModel({
//     required this.content,
//     required this.senderType,
//     required this.createdAt,
//   });
//
//   factory ConversationLastMessageSummaryModel.fromJson(Map<String, dynamic> json) {
//     return ConversationLastMessageSummaryModel(
//       content: json['content'] as String,
//       senderType: json['sender_type'] as String,
//       createdAt: DateTime.parse(json['created_at'] as String),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'content': content,
//       'sender_type': senderType,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
// }
