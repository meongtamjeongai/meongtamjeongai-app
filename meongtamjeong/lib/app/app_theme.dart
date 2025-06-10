import 'package:flutter/material.dart';

final appTheme = ThemeData(
  fontFamily: 'NotoSansKR',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
    displayMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
    bodyLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    labelSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
  ),
  useMaterial3: true, // 선택: Material 3 디자인 사용 여부
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal, // 앱 전반의 포인트 색
  ),
);
