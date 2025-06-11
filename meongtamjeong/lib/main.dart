import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meongtamjeong/app/app.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/firebase_options.dart';
import 'firebase_options.dart';

void main() async {
  // 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MeongTamJeong());
}
