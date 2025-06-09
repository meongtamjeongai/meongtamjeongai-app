import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhishingScreen extends StatefulWidget {
  const PhishingScreen({super.key});

  @override
  State<PhishingScreen> createState() => _PhishingScreenState();
}

class _PhishingScreenState extends State<PhishingScreen> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.report_problem_outlined,
      'title': '피싱 의심 조사',
      'subtitle': '의심되는 메시지를 분석해드려요',
      'route': '/phishing-detection',
    },
    {
      'icon': Icons.smart_toy_outlined,
      'title': '피싱 시뮬레이션',
      'subtitle': '상황별 피싱 체험으로 예방해요',
      'route': '/simulation',
    },
    {
      'icon': Icons.translate,
      'title': '의심 문자 번역',
      'subtitle': '낯선 언어를 번역해드릴게요',
      'route': '/translation',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // centerTitle: true,
        title: const Text(
          '피싱방지 기능을 선택해주세요',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/characters/example_meong.png',
              height: 230,
            ),
            const SizedBox(height: 24),
            ...menuItems.map((item) => _buildMenuCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        context.push(item['route']);
      },
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
