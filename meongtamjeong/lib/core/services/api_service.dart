// meongtamdjeong_flutter/lib/services/api_service.dart
// FastAPI 백엔드와의 HTTP 통신을 담당하는 서비스 (QueuedInterceptorsWrapper 적용)

import 'dart:io';

import 'package:dio/dio.dart'; // 'as dio' 접두사 제거 (일반적인 사용 방식으로 복귀)
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';
import 'package:meongtamjeong/domain/models/message_model.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/domain/models/persona_update_model.dart';
import 'package:meongtamjeong/domain/models/token_model.dart';
import 'package:meongtamjeong/domain/models/user_model.dart';
import 'package:meongtamjeong/domain/models/user_update_model.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveUserProfile({
    required String uid,
    required String username,
    File? profileImageFile,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('uid', uid),
        MapEntry('username', username),
      ]);

      if (profileImageFile != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              profileImageFile.path,
              filename: 'profile.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await _dio.post('/users/profile', data: formData);

      if (response.statusCode == 200) {
        print('✅ 사용자 프로필 저장 성공');
      } else {
        throw Exception('❌ 사용자 프로필 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('ApiService: saveUserProfile Error: $e');
      rethrow;
    }
  }

  static const String _baseUrl = "https://meong.shop/api/v1";

  // 토큰 갱신 이벤트 알림을 위한 ValueNotifier
  // UI에서 이 값을 리스닝하여 토큰 갱신 시 피드백을 줄 수 있음
  final ValueNotifier<int> tokenRefreshNotifier = ValueNotifier(0);

  ApiService() {
    _dio = Dio();
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 15000);

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        // QueuedInterceptorsWrapper 사용
        onRequest: (options, handler) async {
          final accessToken = await _secureStorage.read(
            key: 'service_access_token',
          );
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          print("ApiService ▶️ Request [${options.method}] ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            "ApiService ◀️ Response [${response.requestOptions.method}] ${response.requestOptions.path}, Status: ${response.statusCode}",
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          print(
            "ApiService ❌ Error [${e.requestOptions.method}] ${e.requestOptions.path}, Status: ${e.response?.statusCode}",
          );

          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('/token/refresh')) {
            print(
              "ApiService ❗ 401 Unauthorized Error detected. Token might be expired.",
            );

            try {
              print("ApiService 🔄 Attempting to refresh token...");
              final bool tokenRefreshed = await _refreshAccessToken();

              if (tokenRefreshed) {
                print(
                  "ApiService ✅ Token refreshed successfully. Retrying original request to ${e.requestOptions.path}.",
                );
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } else {
                print(
                  "ApiService ❌ Refresh token failed. Propagating original 401 error.",
                );
              }
            } catch (refreshError) {
              print(
                "ApiService ❌ Catch block for refresh token error: $refreshError",
              );
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  // Dio get dio => _dio; //user_profile_service.dart gatter용

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: 'service_refresh_token',
      );
      if (refreshToken == null) {
        print(
          "ApiService (_refreshAccessToken): ⛔ No refresh token found in storage.",
        );
        return false;
      }

      print(
        "ApiService (_refreshAccessToken): ➡️ Sending refresh token to backend...",
      );
      final refreshDio = Dio();
      refreshDio.options.baseUrl = _baseUrl;

      final response = await refreshDio.post(
        '/auth/token/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data['access_token'] as String?;
        if (newAccessToken != null) {
          await _secureStorage.write(
            key: 'service_access_token',
            value: newAccessToken,
          );
          print(
            "ApiService (_refreshAccessToken): ✨ New access token stored successfully.",
          );
          // 토큰 갱신 성공 이벤트 알림
          tokenRefreshNotifier.value++;
          return true;
        }
      }
      print(
        "ApiService (_refreshAccessToken): ⛔ Failed to get new access token from backend. Logging out.",
      );
      await deleteServiceTokens();
      return false;
    } catch (e) {
      print(
        "ApiService (_refreshAccessToken): ⛔ Error refreshing access token: $e. Logging out.",
      );
      await deleteServiceTokens();
      return false;
    }
  }

  // --- 기존 API 호출 메서드들 (변경 없음) ---
  Future<Token?> authenticateWithFirebaseToken(String firebaseIdToken) async {
    try {
      final response = await _dio.post(
        '/auth/firebase/token',
        data: {'token': firebaseIdToken},
      );
      if (response.statusCode == 200 && response.data != null) {
        final token = Token.fromJson(response.data);
        await _secureStorage.write(
          key: 'service_access_token',
          value: token.accessToken,
        );
        if (token.refreshToken != null) {
          await _secureStorage.write(
            key: 'service_refresh_token',
            value: token.refreshToken,
          );
        }
        return token;
      }
    } catch (e) {
      print("ApiService: authenticateWithFirebaseToken Error: $e");
    }
    return null;
  }

  Future<void> deleteServiceTokens() async {
    await _secureStorage.delete(key: 'service_access_token');
    await _secureStorage.delete(key: 'service_refresh_token');
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      print("ApiService: getCurrentUser Error: $e");
    }
    return null;
  }

  Future<UserModel?> updateUserInfo(UserUpdateModel updateData) async {
    try {
      print("ApiService: Attempting to update user info...");
      final response = await _dio.put('/users/me', data: updateData.toJson());

      if (response.statusCode == 200 && response.data != null) {
        print("ApiService: Successfully updated user info.");
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      print("ApiService: updateUserInfo Error: $e");
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> deactivateAccount() async {
    try {
      print("ApiService: Attempting to deactivate account...");
      final response = await _dio.delete('/users/me');

      if (response.statusCode == 200 && response.data != null) {
        print("ApiService: Account deactivation request successful.");
        return response.data as Map<String, dynamic>; // {"message": "..."}
      }
    } catch (e) {
      print("ApiService: deactivateAccount Error: $e");
      rethrow;
    }
    return null;
  }

  Future<List<ConversationModel>> getUserConversations({
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        '/conversations/',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((json) => ConversationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("ApiService: getUserConversations Error: $e");
    }
    return [];
  }

  Future<String?> getPresignedImageUrl(String objectKey) async {
    try {
      final response = await _dio.get(
        '/storage/presigned-url/download',
        queryParameters: {'object_key': objectKey},
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data['url'] as String?;
      }
    } catch (e) {
      print("ApiService: getPresignedImageUrl Error: $e");
    }
    return null;
  }

  Future<ConversationModel?> startNewConversation({
    required int personaId,
    String? title,
  }) async {
    try {
      final Map<String, dynamic> requestData = {'persona_id': personaId};
      if (title != null && title.isNotEmpty) requestData['title'] = title;
      final response = await _dio.post('/conversations/', data: requestData);
      if (response.statusCode == 201 && response.data != null) {
        return ConversationModel.fromJson(response.data);
      }
    } catch (e) {
      print("ApiService: startNewConversation Error: $e");
      rethrow;
    }
    return null;
  }

  Future<List<MessageModel>> getConversationMessages(
    int conversationId, {
    int skip = 0,
    int limit = 50,
    bool sortAsc = true,
  }) async {
    try {
      final response = await _dio.get(
        '/conversations/$conversationId/messages/',
        queryParameters: {'skip': skip, 'limit': limit, 'sort_asc': sortAsc},
      );
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("ApiService: getConversationMessages Error: $e");
    }
    return [];
  }

  Future<List<MessageModel>?> sendNewMessage(
    int conversationId,
    String content,
  ) async {
    try {
      final response = await _dio.post(
        '/conversations/$conversationId/messages/',
        data: {'content': content},
      );
      if (response.statusCode == 201 && response.data != null) {
        return (response.data as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("ApiService: sendNewMessage Error: $e");
      rethrow;
    }
    return null;
  }

  // --- 페르소나 ---
  Future<List<PersonaModel>> getPersonas({
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        '/personas/',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList.map((json) => PersonaModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("ApiService: getPersonas Error: $e");
    }
    return [];
  }

  // 페르소나 상세 조회 메서드 추가
  Future<PersonaModel?> getPersonaById(int personaId) async {
    try {
      final response = await _dio.get('/personas/$personaId');
      if (response.statusCode == 200 && response.data != null) {
        return PersonaModel.fromJson(response.data);
      }
    } catch (e) {
      print("ApiService: getPersonaById Error: $e");
    }
    return null;
  }

  // 페르소나 생성 메서드 구현
  Future<PersonaModel?> createPersona({
    required String name,
    required String systemPrompt,
    String? description,
    bool isPublic = true,
  }) async {
    try {
      final response = await _dio.post(
        '/personas/',
        data: {
          'name': name,
          'system_prompt': systemPrompt,
          'description': description,
          'is_public': isPublic,
        },
      );
      if (response.statusCode == 201 && response.data != null) {
        return PersonaModel.fromJson(response.data);
      }
    } catch (e) {
      print("ApiService: createPersona Error: $e");
      rethrow; // UI에서 오류를 처리할 수 있도록 다시 던짐
    }
    return null;
  }

  // 페르소나 수정 메서드 추가
  Future<PersonaModel?> updatePersona(
    int personaId,
    PersonaUpdateModel personaUpdate,
  ) async {
    try {
      // toJson()은 null이 아닌 필드만 포함하므로 부분 업데이트가 가능
      final response = await _dio.put(
        '/personas/$personaId',
        data: personaUpdate.toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        return PersonaModel.fromJson(response.data);
      }
    } catch (e) {
      print("ApiService: updatePersona Error: $e");
      rethrow;
    }
    return null;
  }

  // 페르소나 삭제 메서드 추가
  Future<bool> deletePersona(int personaId) async {
    try {
      final response = await _dio.delete('/personas/$personaId');
      // 204 No Content는 성공적으로 삭제되었음을 의미
      return response.statusCode == 204;
    } catch (e) {
      print("ApiService: deletePersona Error: $e");
      rethrow;
    }
    return false;
  }
}
