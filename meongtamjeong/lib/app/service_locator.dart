import 'package:get_it/get_it.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';
import 'package:meongtamjeong/core/services/api_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // 싱글톤으로 등록
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ApiService>(() => ApiService());
}
