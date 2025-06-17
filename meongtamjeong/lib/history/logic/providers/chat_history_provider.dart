import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

class ChatHistoryProvider with ChangeNotifier {
  final ApiService _apiService;

  List<ConversationModel> _conversations = [];
  bool _isLoading = false;
  String? _errorMessage;

  ChatHistoryProvider({required ApiService apiService}) : _apiService = apiService {
    fetchConversations();
  }

  // Getters
  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchConversations({bool forceRefresh = false}) async {
    // 강제 새로고침이 아니면 로딩 중일 때 중복 호출 방지
    if (_isLoading && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    // 새로고침이 아닐 경우, UI에 즉시 로딩 상태 반영
    if (!forceRefresh) {
      notifyListeners();
    }
    
    try {
      // API 호출
      final fetchedList = await _apiService.getUserConversations();
      _conversations = fetchedList;
    } catch (e) {
      _errorMessage = "대화 목록을 불러오는 데 실패했습니다.";
      print('❌ 대화 목록 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}