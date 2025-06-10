import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/image_picker_widget.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/safety_guide_card.dart';
import 'package:meongtamjeong/navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class DetectionMainScreen extends StatelessWidget {
  const DetectionMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCharacter =
        context.watch<CharacterProvider>().selectedCharacter;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text(
          '피싱 의심 조사',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/characters/example_meong.png',
              height: 120,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                '“의심스러운 메시지를 받으셨나요? 🤔\n직접 클릭은 위험해요. 캡처해서 올려주세요!\n안전하게 분석해드릴게요.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const ImagePickerWidget(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/loading'); // 예: 분석 로딩 화면
                },
                icon: const Icon(Icons.shield, color: Colors.white),
                label: const Text(
                  '피싱 조사하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SafetyGuideCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (currentCharacter == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('캐릭터가 선택되지 않았습니다.')));
            return;
          }
          context.goNamed(
            'main',
            extra: {'character': currentCharacter, 'index': index},
          );
        },
      ),
    );
  }
}
