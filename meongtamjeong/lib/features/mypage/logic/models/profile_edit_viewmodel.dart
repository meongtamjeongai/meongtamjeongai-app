import 'dart:io';
import 'package:flutter/material.dart';

class ProfileEditViewModel extends ChangeNotifier {
  File? _profileImage;
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameConfirmed = false;

  ProfileEditViewModel() {
    _nicknameController.addListener(notifyListeners);
  }

  File? get profileImage => _profileImage;
  TextEditingController get nicknameController => _nicknameController;
  bool get isNicknameConfirmed => _isNicknameConfirmed;
  bool get canSubmit =>
      _nicknameController.text.trim().isNotEmpty && _isNicknameConfirmed;

  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void confirmNickname() {
    final nickname = _nicknameController.text.trim();
    if (nickname.isNotEmpty && nickname.runes.length <= 10) {
      _isNicknameConfirmed = true;
    } else {
      _isNicknameConfirmed = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}
