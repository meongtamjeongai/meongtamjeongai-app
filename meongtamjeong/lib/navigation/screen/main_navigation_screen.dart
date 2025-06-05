import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/chat_screen.dart';
import 'package:meongtamjeong/features/home/presentation/screens/main_home_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/mypage_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screens/phishing_screen.dart';
import 'package:meongtamjeong/history/screen/chat_history_screen.dart';
import 'package:meongtamjeong/features/character_selection/logic/models/character_model.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final CharacterModel character;
  final int? initialIndex; // 초기 인덱스 설정용

  const MainNavigationScreen({
    super.key,
    required this.character,
    this.initialIndex,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 2; // 기본값은 채팅 화면
    _screens = [
      const MainHomeScreen(),
      const PhishingScreen(),
      ChatScreen(character: widget.character),
      const ChatHistoryScreen(),
      const MyPageScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print('탭 클릭됨: $index (이전: $_currentIndex)');
          setState(() {
            _currentIndex = index;
            print('상태 변경 완료: $_currentIndex');
          });
        },
      ),
    );
  }
}
