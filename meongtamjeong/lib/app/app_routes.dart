import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/login_screen.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:meongtamjeong/features/character_selection/logic/models/character_model.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_detail_screen.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_list_screen.dart';
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

    GoRoute(
      path: '/character-select',
      name: 'character-select',
      builder: (context, state) => const ProfileSetupScreen(),
    ),

    GoRoute(
      path: '/character-list',
      name: 'character-list',
      builder: (context, state) => const CharacterListScreen(),
    ),

    GoRoute(
      path: '/character-detail',
      name: 'character-detail',
      builder: (context, state) {
        final character = state.extra as CharacterModel;
        return CharacterDetailScreen(character: character);
      },
    ),
  ],
);
