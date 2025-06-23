import 'package:flutter/foundation.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/user_model.dart';

class UserProfileProvider extends ChangeNotifier {
  UserModel? _user;
  final ApiService apiService;

  UserProfileProvider(this.apiService);

  UserModel? get user => _user;

  Future<void> loadUserProfile() async {
    try {
      final profile = await apiService.getCurrentUser();
      _user = profile;
      notifyListeners();
    } catch (e) {
      print('❌ 사용자 정보 로딩 실패: $e');
    }
  }

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }
}
