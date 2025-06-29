import 'package:flutter/material.dart';
import 'package:meongtamjeong/app/service_locator.dart';

import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';
import 'package:meongtamjeong/features/auth/logic/providers/user_profile_provider.dart';
import 'package:meongtamjeong/features/chat/logic/providers/conversation_provider.dart';
import 'package:meongtamjeong/features/mypage/logic/models/profile_edit_viewmodel.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'app_theme.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class MeongTamJeong extends StatelessWidget {
  const MeongTamJeong({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileEditViewModel(locator<ApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => locator<AuthService>()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        Provider(create: (_) => locator<ApiService>()),
        //  다른 Provider 추가 가능
      ],
      child: MaterialApp.router(
        title: '멍탐정',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routerConfig: router,
      ),
    );
  }
}
