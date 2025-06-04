import 'package:flutter/material.dart';
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
