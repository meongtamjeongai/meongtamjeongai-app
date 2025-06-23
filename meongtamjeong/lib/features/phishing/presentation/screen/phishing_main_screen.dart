import 'package:flutter/material.dart';
import 'phishing_sub_router_screen.dart';

class PhishingMainScreen extends StatefulWidget {
  const PhishingMainScreen({super.key});

  @override
  State<PhishingMainScreen> createState() => _PhishingMainScreenState();
}

class _PhishingMainScreenState extends State<PhishingMainScreen> {
  String? selectedSub; // ✅ null이면 메뉴 화면, 값이 있으면 해당 서브화면

  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.report_problem_outlined,
      'title': '피싱 의심 조사',
      'subtitle': '의심되는 메시지를 분석해드려요',
      'sub': 'investigation',
    },
    {
      'icon': Icons.smart_toy_outlined,
      'title': '피싱 시뮬레이션',
      'subtitle': '상황별 피싱 체험으로 예방해요',
      'sub': 'simulation',
    },
    {
      'icon': Icons.description,
      'title': '피해 대처 가이드',
      'subtitle': '신고 방법과 대처법을 안내해드려요',
      'sub': 'guide',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ 메뉴 항목 선택되면 서브 화면 보여주기
    if (selectedSub != null) {
      return PhishingSubRouterScreen(
        sub: selectedSub!,
        onBack: () => setState(() => selectedSub = null), // 뒤로가기 → 메뉴로
      );
    }

    // ✅ 초기 메뉴 선택 화면
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '피싱방지 기능을 선택해주세요',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/characters/example_meong.png',
              height: 320,
            ),
            const SizedBox(height: 10),
            ...menuItems.map(_buildMenuCard),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => setState(() => selectedSub = item['sub']), // ✅ 화면 전환
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(item['icon'], size: 40, color: Colors.blue),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['subtitle'],
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
