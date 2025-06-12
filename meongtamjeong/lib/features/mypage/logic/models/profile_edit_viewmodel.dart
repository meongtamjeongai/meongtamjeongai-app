// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:meongtamjeong/core/services/api_service.dart';

// class ProfileEditViewModel extends ChangeNotifier {
//   File? _profileImage;
//   final TextEditingController _nicknameController = TextEditingController();
//   bool _isNicknameConfirmed = false;
//   final ApiService _apiService;

//   ProfileEditViewModel(this._apiService) {
//     _nicknameController.addListener(notifyListeners);
//   }

//   File? get profileImage => _profileImage;
//   TextEditingController get nicknameController => _nicknameController;
//   bool get isNicknameConfirmed => _isNicknameConfirmed;
//   bool get canSubmit =>
//       _nicknameController.text.trim().isNotEmpty && _isNicknameConfirmed;

//   void setProfileImage(File image) {
//     _profileImage = image;
//     notifyListeners();
//   }

//   void confirmNickname() {
//     final nickname = _nicknameController.text.trim();
//     if (nickname.isNotEmpty && nickname.runes.length <= 10) {
//       _isNicknameConfirmed = true;
//     } else {
//       _isNicknameConfirmed = false;
//     }
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _nicknameController.dispose();
//     super.dispose();
//   }

//   Future<bool> saveProfileChanges() async {
//     final nickname = _nicknameController.text.trim();
//     if (nickname.isEmpty || nickname.runes.length > 10) {
//       return false;
//     }

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception('로그인된 사용자가 없습니다.');
//       }

//       await _apiService.saveUserProfile(
//         uid: user.uid,
//         nickname: nickname,
//         profileImageFile: _profileImage,
//       );
//       return true;
//     } catch (e) {
//       print("ProfileEditViewModel: 프로필 저장 오류 - $e");
//       return false;
//     }
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/user_model.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final ApiService _apiService;

  File? _profileImage;
  final TextEditingController _usernameController = TextEditingController();

  bool _isUsernameConfirmed = false;
  bool _isLoading = false;

  String? _errorMessage;
  String? _successMessage;

  ProfileEditViewModel(this._apiService) {
    _usernameController.addListener(notifyListeners);
  }

  // --- Getters ---
  File? get profileImage => _profileImage;
  TextEditingController get usernameController => _usernameController;
  bool get isUsernameConfirmed => _isUsernameConfirmed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get canSubmit =>
      _usernameController.text.trim().isNotEmpty &&
      _isUsernameConfirmed &&
      !_isLoading;

  // --- Public Methods ---
  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void confirmUsername() {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty && username.runes.length <= 10) {
      _isUsernameConfirmed = true;
      _errorMessage = null;
    } else {
      _isUsernameConfirmed = false;
      _errorMessage = '사용자 이름은 1~10자 이내여야 합니다.';
    }
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('로그인된 사용자가 없습니다.');

      final UserModel? userInfo = await _apiService.getCurrentUser();
      if (userInfo != null) {
        _usernameController.text = userInfo.username ?? '';
        _isUsernameConfirmed = true;
        notifyListeners();
      }
    } catch (e) {
      print("ProfileEditViewModel: 사용자 정보 불러오기 실패 - $e");
    }
  }

  Future<bool> saveProfileChanges() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty || username.runes.length > 10) {
      _errorMessage = '사용자 이름은 1~10자 이내로 입력해주세요.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      await _apiService.saveUserProfile(
        uid: user.uid,
        username: username, // 백엔드 키가 아직 nickname이라면 그대로 사용
        profileImageFile: _profileImage,
      );

      _successMessage = "프로필이 성공적으로 저장되었습니다.";
      return true;
    } catch (e) {
      print("ProfileEditViewModel: 프로필 저장 오류 - $e");
      _errorMessage = "프로필 저장 중 오류가 발생했습니다.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
