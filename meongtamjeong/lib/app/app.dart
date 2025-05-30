import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'app_theme.dart';

class MeongTamJeong extends StatelessWidget {
  const MeongTamJeong({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '멍탐정',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: router,
    );
  }
}
