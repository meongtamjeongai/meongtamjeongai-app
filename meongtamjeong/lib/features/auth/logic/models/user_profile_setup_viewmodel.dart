import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';

class UserProfileSetupViewModel extends ChangeNotifier {
  File? _profileImage;
  final TextEditingController _usernameController = TextEditingController();
  bool _isUsernameConfirmed = false;
  bool _isLoading = false;
  String? _errorMessage;

  final ApiService _apiService = locator<ApiService>();

  UserProfileSetupViewModel() {
    _usernameController.addListener(notifyListeners);
  }

  // Getters
  File? get profileImage => _profileImage;
  TextEditingController get usernameController => _usernameController;
  bool get isUsernameConfirmed => _isUsernameConfirmed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canSubmit => _isUsernameValid && _isUsernameConfirmed && !_isLoading;

  bool get _isUsernameValid {
    final username = _usernameController.text.trim();
    return username.isNotEmpty &&
        username.runes.length <= 10 &&
        username.trim().isNotEmpty;
  }

  // Actions
  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void confirmUsername() {
    final username = _usernameController.text.trim();
    final error = validateUsername(username);

    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return;
    }

    _isUsernameConfirmed = true;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateUsername(String username) {
    if (username.isEmpty) return '이름을 입력해주세요';
    if (username.trim().isEmpty) return '공백만 입력할 수 없어요';
    if (username.runes.length > 10) return '10자 이내로 입력해주세요';
    return null;
  }

  Future<bool> submitProfile() async {
    if (!canSubmit) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _errorMessage = '로그인된 사용자가 없습니다.';
        return false;
      }

      final uid = user.uid;
      final username = _usernameController.text.trim();

      await _apiService.saveUserProfile(
        uid: uid,
        username: username,
        profileImageFile: _profileImage,
      );

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
      'username': _usernameController.text.trim(),
      'hasImage': _profileImage != null,
      'imagePath': _profileImage?.path,
    };
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
