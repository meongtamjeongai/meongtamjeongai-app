// meongtamdjeong_flutter/lib/models/conversation_model.dart
// 백엔드로부터 받는 대화방 정보를 담는 모델 (ConversationResponse 대응)

import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/domain/models/message_model.dart';

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
      // 🔧 시간 파싱 로직 개선
      createdAt: _parseDateTime(json['created_at'] as String),
      lastMessageAt: _parseDateTime(json['last_message_at'] as String),
    );
  }

  // 🆕 안전한 DateTime 파싱 메서드
  static DateTime _parseDateTime(String dateTimeString) {
    try {
      DateTime parsed = DateTime.parse(dateTimeString);

      // UTC 시간인지 확인 (Z가 붙어있거나 isUtc가 true인 경우)
      if (dateTimeString.endsWith('Z') || parsed.isUtc) {
        return parsed.toLocal(); // UTC → 로컬 시간으로 변환
      } else {
        // 이미 로컬 시간이거나 시간대 정보가 없는 경우
        // 서버가 한국 시간대로 저장하고 있다면 그대로 사용
        return parsed;
      }
    } catch (e) {
      debugPrint('❌ DateTime 파싱 실패: $dateTimeString, 에러: $e');
      return DateTime.now(); // 파싱 실패 시 현재 시간 반환
    }
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

extension ConversationModelCopy on ConversationModel {
  ConversationModel copyWith({
    int? id,
    int? userId,
    String? title,
    PersonaModel? persona,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      persona: persona ?? this.persona,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
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

// 백엔드의 schemas.message.ChatMessageResponse 에 대응하는 모델
class ChatMessageResponse {
  final MessageModel userMessage;
  final MessageModel aiMessage;
  final List<String> suggestedUserQuestions;
  final bool isReadyToMoveOn;

  ChatMessageResponse({
    required this.userMessage,
    required this.aiMessage,
    required this.suggestedUserQuestions,
    required this.isReadyToMoveOn,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      userMessage: MessageModel.fromJson(json['user_message']),
      aiMessage: MessageModel.fromJson(json['ai_message']),
      suggestedUserQuestions: List<String>.from(
        json['suggested_user_questions'],
      ),
      isReadyToMoveOn: json['is_ready_to_move_on'],
    );
  }
}
