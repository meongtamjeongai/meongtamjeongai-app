import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/auth/data/datasources/dummy_user_api.dart';

class UserProfileSetupViewModel extends ChangeNotifier {
  File? _profileImage;
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameConfirmed = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfileSetupViewModel() {
    _nicknameController.addListener(notifyListeners);
  }

  // Getters
  File? get profileImage => _profileImage;
  TextEditingController get nicknameController => _nicknameController;
  bool get isNicknameConfirmed => _isNicknameConfirmed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canSubmit => _isNicknameValid && _isNicknameConfirmed && !_isLoading;

  bool get _isNicknameValid {
    final nickname = _nicknameController.text.trim();
    return nickname.isNotEmpty &&
        nickname.runes.length <= 10 &&
        nickname.trim().isNotEmpty;
  }

  // Actions
  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void confirmNickname() {
    final nickname = _nicknameController.text.trim();
    final error = validateNickname(nickname);

    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return;
    }

    _isNicknameConfirmed = true;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateNickname(String nickname) {
    if (nickname.isEmpty) return '별명을 입력해주세요';
    if (nickname.trim().isEmpty) return '공백만 입력할 수 없어요';
    if (nickname.runes.length > 10) return '10자 이내로 입력해주세요';
    return null;
  }

  Future<bool> submitProfile() async {
    if (!canSubmit) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DummyUserApi.sendUserProfile(this);
      return true;
    } catch (e) {
      _errorMessage = '프로필 설정 중 오류가 발생했습니다.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': _nicknameController.text.trim(),
      'hasImage': _profileImage != null,
      'imagePath': _profileImage?.path,
    };
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}
