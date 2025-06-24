// main_navigation_screen.dart
import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/chat_screen.dart';
import 'package:meongtamjeong/features/home/presentation/screens/main_home_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/mypage_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/detection_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/phishing_handling_guide_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/phishing_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screen/simulation_main_screen.dart';
import 'package:meongtamjeong/history/screen/chat_history_screen.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final String? sub;

  const MainNavigationScreen({super.key, this.initialIndex = 2, this.sub});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  String? _sub;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _sub = widget.sub;
  }

  @override
  void didUpdateWidget(covariant MainNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ 항상 현재 상태와 비교해서 변경 반영
    if (_currentIndex != widget.initialIndex || _sub != widget.sub) {
      setState(() {
        _currentIndex = widget.initialIndex;
        _sub = widget.sub;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MainHomeScreen(),
      _sub == null
          ? const PhishingMainScreen() // 기능 선택 화면
          : _buildPhishingScreen(_sub), // 기능별 상세화면
      const ChatScreen(),
      const ChatHistoryScreen(),
      const MyPageScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _sub = null;
          });
        },
      ),
    );
  }

  Widget _buildPhishingScreen(String? sub) {
    switch (sub) {
      case 'simulation':
        return SimulationMainScreen(
          onBack: () {
            setState(() {
              _sub = null;
            });
          },
        );
      case 'guide':
        return PhishingHandlingGuideScreen(
          onBack: () {
            setState(() {
              _sub = null;
            });
          },
        );
      case 'investigation':
      default:
        return DetectionMainScreen(
          onBack: () {
            setState(() {
              _sub = null;
            });
          },
        );
    }
  }
}
