import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/login_screen.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:meongtamjeong/features/character_selection/logic/models/character_model.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_detail_screen.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_list_screen.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/chat_screen.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/file_attachment_screen.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/image_attachment_screen.dart';
import 'package:meongtamjeong/features/home/presentation/screens/main_home_screen.dart';
import 'package:meongtamjeong/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screens/phishing_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/mypage_main_screen.dart';
import 'package:meongtamjeong/history/screen/chat_history_screen.dart';
import 'package:meongtamjeong/navigation/screen/main_navigation_screen.dart';

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

    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final character = state.extra as CharacterModel;
        return ChatScreen(character: character);
      },
    ),

    GoRoute(
      path: '/file-attachment',
      name: 'file-attachment',
      builder: (context, state) => const FileAttachmentScreen(),
    ),

    GoRoute(
      path: '/image-attachment',
      name: 'image-attachment',
      builder: (context, state) => const ImageAttachmentScreen(),
    ),

    GoRoute(
      path: '/nav',
      name: 'nav',
      builder: (context, state) {
        final character = state.extra as CharacterModel;
        return MainNavigationScreen(character: character);
      },
    ),

    // 아래는 직접 접근이 필요한 경우만 허용
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (_, __) => const MainHomeScreen(),
    ),
    GoRoute(
      path: '/phishing',
      name: 'phishing',
      builder: (_, __) => const PhishingScreen(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (_, __) => const ChatHistoryScreen(),
    ),
    GoRoute(
      path: '/mypage',
      name: 'mypage',
      builder: (_, __) => const MyPageScreen(),
    ),
  ],
);
