import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/login_screen.dart';
import 'package:meongtamjeong/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_detail_screen.dart';
import 'package:meongtamjeong/features/character_selection/presentation/screens/character_list_screen.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/file_attachment_screen.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/image_attachment_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/app_info_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/faq_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/heart_recharge_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/notice_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/privacy_policy_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/profile_edit_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/terms_webview_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/detection_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/detection_result_detail_screen.dart';
import 'package:meongtamjeong/navigation/screen/main_navigation_screen.dart';
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
      path: '/username-setup',
      name: 'username-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),

    GoRoute(
      path: '/character-select',
      builder: (context, state) => const CharacterListScreen(),
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
        final extra = state.extra;
        if (extra == null || extra is! PersonaModel) {
          debugPrint('❌ state.extra is null or not PersonaModel!');
          // fallback 화면을 보여주거나 에러 처리
          return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
        }

        final persona = extra;
        return CharacterDetailScreen(character: persona);
      },
    ),

    GoRoute(
      path: '/main',
      name: 'main',
      builder: (context, state) {
        final extra = state.extra;
        if (extra == null || extra is! Map) {
          return const Scaffold(body: Center(child: Text('잘못된 접근입니다.')));
        }

        final data = extra as Map<String, dynamic>;
        final index = data['index'] as int? ?? 2;
        final sub = data['sub'] as String?;

        return MainNavigationScreen(initialIndex: index, sub: sub);
      },
    ),

    GoRoute(
      path: '/phishing-detection',
      name: 'phishing-detection',
      builder: (context, state) => const DetectionMainScreen(),
    ),

    GoRoute(
      path: '/result',
      name: 'phishing-result',
      builder: (context, state) => const ResultDetailScreen(),
    ),

    GoRoute(
      path: '/profile-edit',
      name: 'profile-edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),

    GoRoute(
      path: '/heart-recharge',
      name: 'heart-recharge',
      builder: (context, state) => const HeartRechargeScreen(),
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
      path: '/faq',
      name: 'faq',
      builder: (context, state) => const FAQWebViewScreen(),
    ),

    GoRoute(
      path: '/privacy',
      name: 'privacy-policy',
      builder: (context, state) => const PrivacyPolicyWebViewScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const TermsWebViewScreen(),
    ),
    GoRoute(
      path: '/app-info',
      name: 'app-info',
      builder: (context, state) => const AppInfoWebViewScreen(),
    ),

    GoRoute(
      path: '/notices',
      name: 'notices',
      builder: (context, state) => const NoticesScreen(),
    ),
  ],
);
