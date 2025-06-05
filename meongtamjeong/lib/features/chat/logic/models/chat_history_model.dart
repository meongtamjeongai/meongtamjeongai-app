import '../../../character_selection/logic/models/character_model.dart';

class ChatHistoryModel {
  final CharacterModel character;
  final String lastMessage;
  final DateTime lastTimestamp;

  ChatHistoryModel({
    required this.character,
    required this.lastMessage,
    required this.lastTimestamp,
  });
}
