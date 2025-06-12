import 'package:meongtamjeong/domain/models/persona_model.dart';

class ChatHistoryModel {
  final PersonaModel persona;
  final String lastMessage;
  final DateTime lastTimestamp;

  ChatHistoryModel({
    required this.persona,
    required this.lastMessage,
    required this.lastTimestamp,
  });
}
