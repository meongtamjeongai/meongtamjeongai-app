import 'package:get_it/get_it.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // ApiService 등록
  locator.registerLazySingleton<ApiService>(() => ApiService());

  // AuthService 등록
  locator.registerLazySingleton<AuthService>(() => AuthService());
}
