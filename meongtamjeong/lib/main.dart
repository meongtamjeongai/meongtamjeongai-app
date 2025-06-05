import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meongtamjeong/app/app.dart';

void main() async {
  // 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  runApp(const MeongTamJeong());
}
