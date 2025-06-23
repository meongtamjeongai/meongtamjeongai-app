// lib/core/services/phishing_simulation_service.dart
import 'package:dio/dio.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_case_model.dart';
import 'package:meongtamjeong/features/phishing/logic/model/simulation_session_model.dart';

class PhishingSimulationService {
  final Dio _dio = ApiService().dio;

  /// 카테고리로 시뮬레이션 세션 생성
  Future<SimulationSession> createConversationWithCategory(
    String categoryCode,
  ) async {
    final response = await _dio.post(
      '/conversations/with-category',
      data: {'category_code': categoryCode},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SimulationSession.fromJson(response.data);
    } else {
      throw Exception('시뮬레이션 세션 생성 실패: ${response.statusCode}');
    }
  }

  /// 시뮬레이션 메시지 전송 → AI 응답 수신
  Future<String> sendMessageToSimulation({
    required int conversationId,
    required String message,
  }) async {
    final response = await _dio.post(
      '/conversations/$conversationId/messages',
      data: {'content': message},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['ai_message']['content']; // 응답 메시지 추출
    } else {
      throw Exception('AI 메시지 전송 실패: ${response.statusCode}');
    }
  }

  /// 선택한 카테고리 기준으로 피싱 사례 불러오기
  Future<List<PhishingCase>> fetchCasesByCategory(String categoryCode) async {
    final response = await _dio.get('/phishing/categories/$categoryCode/cases');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => PhishingCase.fromJson(e)).toList();
    } else {
      throw Exception('피싱 사례 불러오기 실패: ${response.statusCode}');
    }
  }

  /// 특정 피싱 사례 상세 데이터 조회
  Future<PhishingCase> fetchCaseDetail(int caseId) async {
    final response = await _dio.get('/phishing/cases/$caseId');

    if (response.statusCode == 200) {
      return PhishingCase.fromJson(response.data);
    } else {
      throw Exception('피싱 사례 상세조회 실패: ${response.statusCode}');
    }
  }
}
