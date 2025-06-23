import 'dart:io';
import 'package:flutter/foundation.dart';
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
    _usernameController.addListener(() {
      _isUsernameConfirmed = false; // 입력이 변경되면 확인 상태 해제
      notifyListeners();
    });
  }

  // --- Getters ---
  File? get profileImage => _profileImage;
  TextEditingController get usernameController => _usernameController;
  bool get isUsernameConfirmed => _isUsernameConfirmed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get canSubmit => _isUsernameValid && _isUsernameConfirmed && !_isLoading;

  bool get _isUsernameValid {
    final username = _usernameController.text;
    return username.isNotEmpty && username.runes.length <= 10;
  }

  // --- Public Methods ---
  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void updateUsername(String text) {
    _usernameController.text = text;
    _isUsernameConfirmed = false;
    notifyListeners();
  }

  void confirmUsername() {
    final name = _usernameController.text;
    if (name.isEmpty) {
      _errorMessage = '이름을 입력해주세요';
    } else if (name.runes.length > 10) {
      _errorMessage = '10자 이내로 입력해주세요';
    } else {
      _errorMessage = null;
      _isUsernameConfirmed = true;
    }
    notifyListeners();
  }

  Future<bool> submitProfile() async {
    if (!canSubmit) return false;

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final username = _usernameController.text;

      await _apiService.saveUserProfile(
        username: username,
        profileImageFile: _profileImage,
      );

      _successMessage = "프로필이 저장되었습니다.";
      return true;
    } catch (e) {
      _errorMessage = "프로필 저장 중 오류가 발생했습니다.";
      print("❌ 프로필 저장 오류: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initialize(UserModel user) async {
    _usernameController.text = user.username ?? '';
    _isUsernameConfirmed = true;

    if (user.profileImageKey != null) {
      final presignedUrl = await _apiService.getPresignedImageUrl(
        user.profileImageKey!,
      );
      if (presignedUrl != null) {
        _profileImage = await _downloadImageFile(presignedUrl);
      }
    }

    notifyListeners();
  }

  Future<File> _downloadImageFile(String url) async {
    final response = await HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close());
    if (response.statusCode == 200) {
      final bytes = await consolidateHttpClientResponseBytes(response);
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/profile_image.jpg');
      return await file.writeAsBytes(bytes);
    } else {
      throw Exception('이미지 다운로드 실패: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
