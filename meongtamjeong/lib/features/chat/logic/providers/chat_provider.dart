import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

import 'package:meongtamjeong/domain/models/message_model.dart' as domain_message;
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';

import 'package:meongtamjeong/domain/models/persona_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_history_model.dart';

class ChatProvider with ChangeNotifier {
  final ConversationModel conversation;
  final ApiService _apiService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ChatMessageModel> messages = [];

  final List<File> pendingImages = [];
  final ScrollController scrollController = ScrollController();

  static final List<ChatHistoryModel> chatHistories = [];

  PersonaModel get persona => conversation.persona; 
  int get conversationId => conversation.id;

  ChatProvider({required this.conversation, required ApiService apiService})
      : _apiService = apiService {
      loadInitialMessages();
  }

  Future<void> loadInitialMessages() async {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
          final List<domain_message.MessageModel> fetchedMessages =
              await _apiService.getConversationMessages(
                  conversationId,
                  sortAsc: true,
              );

          messages = fetchedMessages.map((msg) {
              return ChatMessageModel(
                  from: msg.senderType.name, // 'user' or 'ai'
                  text: msg.content,
                  time: msg.createdAt,
              );
          }).toList();

          print('✅ ${messages.length}개의 메시지를 불러왔습니다.');

      } catch (e) {
          _errorMessage = '메시지를 불러오는 데 실패했습니다.';
          print('❌ 메시지 로드 오류: $e');
      } finally {
          _isLoading = false;
          notifyListeners();
          scrollToBottom();
      }
  }

  void sendMessage(String text, DateTime time) {
    if (text.trim().isEmpty && pendingImages.isEmpty) return;

    if (text.trim().isNotEmpty) {
      messages.add(
        ChatMessageModel(from: 'user', text: text.trim(), time: time),
      );
    }

    for (var img in pendingImages) {
      messages.add(
        ChatMessageModel(from: 'user', text: '[이미지]', image: img, time: time),
      );
    }

    final botMsg = '${persona.name}의 응답이에요!';
    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add(
        ChatMessageModel(
          from: 'ai',
          text: botMsg,
          time: time.add(const Duration(seconds: 1)),
        ),
      );

      chatHistories.removeWhere((e) => e.persona.name == persona.name);
      chatHistories.add(
        ChatHistoryModel(
          persona: persona,
          lastMessage: botMsg,
          lastTimestamp: DateTime.now(),
        ),
      );

      notifyListeners();
      scrollToBottom();
    });

    pendingImages.clear();
    notifyListeners();
    scrollToBottom();
  }

  void pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      final files = picked.map((x) => File(x.path)).toList();
      if (pendingImages.length + files.length <= 4) {
        pendingImages.addAll(files);
        notifyListeners();
      }
    }
  }

  void removeImage(File file) {
    pendingImages.remove(file);
    notifyListeners();
  }

  void scrollToBottom() {
    Timer(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
