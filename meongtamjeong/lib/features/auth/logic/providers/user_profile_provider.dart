// import 'package:flutter/foundation.dart';
// import 'package:meongtamjeong/domain/models/user_model.dart';

// class UserProfileProvider extends ChangeNotifier {
//   UserModel? _user;

//   UserModel? get user => _user;

//   String get username => _user?.username ?? '사용자 없음';
//   String get userId =>
//       _user?.email != null ? '@${_user!.email!.split('@')[0]}' : '@unknown';
//   int get points => _user?.points ?? 0;
//   bool get isGuest => _user?.isGuest ?? false;

//   void setUser(UserModel user) {
//     _user = user;
//     notifyListeners();
//   }

//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }
// }
// user_profile_provider.dart
// lib/features/auth/logic/providers/user_profile_provider.dart
import 'package:flutter/foundation.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/user_model.dart';

class UserProfileProvider extends ChangeNotifier {
  final ApiService apiService;
  UserModel? _user;

  UserProfileProvider(this.apiService);

  UserModel? get user => _user;

  String get username => _user?.username ?? '사용자 없음';
  String get userId =>
      _user?.email != null ? '@${_user!.email!.split('@')[0]}' : '@unknown';
  int get points => _user?.points ?? 0;
  bool get isGuest => _user?.isGuest ?? false;

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

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
