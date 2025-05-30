import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/login_screen.dart';
import 'package:meongtamjeong/features/home/presentation/screens/home_screen.dart';
import 'package:meongtamjeong/features/onboarding/presentation/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
