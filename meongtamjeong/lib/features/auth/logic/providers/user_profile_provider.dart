import 'package:flutter/foundation.dart';
import 'package:meongtamjeong/domain/models/user_model.dart';

class UserProfileProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  String get username => _user?.username ?? '사용자 없음';
  String get userId =>
      _user?.email != null ? '@${_user!.email!.split('@')[0]}' : '@unknown';
  int get points => _user?.points ?? 0;
  bool get isGuest => _user?.isGuest ?? false;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
