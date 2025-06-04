import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/character_selection/data/repositories/character_repository.dart';
import '../models/character_model.dart';

class CharacterProvider with ChangeNotifier {
  final CharacterRepository _repository = CharacterRepository();
  List<CharacterModel> _characters = [];
  CharacterModel? _selectedCharacter;
  bool _isLoading = false;

  List<CharacterModel> get characters => _characters;
  CharacterModel? get selectedCharacter => _selectedCharacter;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _characters = _repository.getCharacters();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCharacter(CharacterModel character) {
    _selectedCharacter = character;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCharacter = null;
    notifyListeners();
  }
}
