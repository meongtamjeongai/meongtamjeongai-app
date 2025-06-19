import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

class ConversationProvider with ChangeNotifier {
  ConversationModel? _current;

  ConversationModel? get current => _current;

  void setConversation(ConversationModel conversation) {
    _current = conversation;
    notifyListeners();
  }

  void clearConversation() {
    _current = null;
    notifyListeners();
  }
}
