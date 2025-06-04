import 'dart:developer';
import 'package:meongtamjeong/features/auth/logic/models/user_profile_setup_viewmodel.dart';

class DummyUserApi {
  static Future<void> sendUserProfile(UserProfileSetupViewModel profile) async {
    await Future.delayed(const Duration(seconds: 1)); // 백엔드 연동 전 임시 테스트용
    log('✅ 사용자 정보 전송됨: ${profile.toJson()}');
  }
}
