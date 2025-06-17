import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';

import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

import 'package:meongtamjeong/domain/models/persona_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_history_model.dart';

class ChatProvider with ChangeNotifier {
  final ConversationModel conversation;
  final ApiService _apiService;

  final List<ChatMessageModel> messages = [];
  final List<File> pendingImages = [];
  final List<File> pendingFiles = [];
  final ScrollController scrollController = ScrollController();

  static final List<ChatHistoryModel> chatHistories = [];

  PersonaModel get persona => conversation.persona; 
  int get conversationId => conversation.id;

  ChatProvider({required this.conversation, required ApiService apiService})
      : _apiService = apiService;

  void sendMessage(String text, DateTime time) {
    if (text.trim().isEmpty && pendingImages.isEmpty && pendingFiles.isEmpty)
      return;

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

    for (var file in pendingFiles) {
      messages.add(
        ChatMessageModel(
          from: 'user',
          text: '[파일] ${file.path.split('/').last}',
          file: file,
          time: time,
        ),
      );
    }

    final botMsg = '${persona.name}의 응답이에요!';
    Future.delayed(const Duration(milliseconds: 500), () {
      messages.add(
        ChatMessageModel(
          from: 'bot',
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
    pendingFiles.clear();
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

  void pickFiles() async {
    final picked = await openFiles();
    if (picked.isNotEmpty) {
      final files = picked.map((x) => File(x.path)).toList();
      if (pendingFiles.length + files.length <= 4) {
        pendingFiles.addAll(files);
        notifyListeners();
      }
    }
  }

  void removeImage(File file) {
    pendingImages.remove(file);
    notifyListeners();
  }

  void removeFile(File file) {
    pendingFiles.remove(file);
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
