import 'package:flutter/material.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

class CharacterProvider with ChangeNotifier {
  final ApiService _apiService = locator<ApiService>();

  List<PersonaModel> _characters = [];
  PersonaModel? _selectedCharacter;
  bool _isLoading = false;

  List<PersonaModel> get characters => _characters;
  PersonaModel? get selectedCharacter => _selectedCharacter;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetched = await _apiService.getPersonas();

      // presigned URL 처리
      _characters = await Future.wait(
        fetched.map((persona) async {
          // profileImageUrl이 없고 profileImageKey만 있는 경우 presigned URL 요청
          if ((persona.profileImageUrl == null ||
                  persona.profileImageUrl!.isEmpty) &&
              persona.profileImageKey != null) {
            try {
              final url = await _apiService.getPresignedImageUrl(
                persona.profileImageKey!,
              );
              return persona.copyWith(profileImageUrl: url);
            } catch (e) {
              debugPrint('presigned URL 요청 실패: ${persona.name} → $e');
              return persona; // 실패 시 그대로 반환
            }
          }
          return persona; // 이미지 URL 이미 존재하는 경우
        }).toList(),
      );
    } catch (e) {
      debugPrint('캐릭터 로딩 오류: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCharacter(PersonaModel character) {
    _selectedCharacter = character;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCharacter = null;
    notifyListeners();
  }
}
