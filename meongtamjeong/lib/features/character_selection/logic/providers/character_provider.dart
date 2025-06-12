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
      _characters = await _apiService.getPersonas();
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
