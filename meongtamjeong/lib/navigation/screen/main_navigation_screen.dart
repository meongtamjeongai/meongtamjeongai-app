import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/chat/presentation/screens/chat_screen.dart';
import 'package:meongtamjeong/features/home/presentation/screens/main_home_screen.dart';
import 'package:meongtamjeong/features/mypage/presentation/screens/mypage_main_screen.dart';
import 'package:meongtamjeong/features/phishing/presentation/screens/phishing_screen.dart';
import 'package:meongtamjeong/history/screen/chat_history_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final PersonaModel persona;
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    required this.persona,
    this.initialIndex = 2,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant MainNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MainHomeScreen(),
      const PhishingScreen(),
      ChatScreen(character: widget.persona),
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
          });
        },
      ),
    );
  }
}
