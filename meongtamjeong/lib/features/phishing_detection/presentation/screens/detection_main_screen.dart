import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/phishing_detection/presentation/widgets/image_picker_widget.dart';
import 'package:meongtamjeong/navigation/widgets/custom_bottom_nav_bar.dart';

class DetectionMainScreen extends StatelessWidget {
  const DetectionMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: [
            Image.asset(
              'assets/images/characters/example_meong.png',
              height: 120,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                '피싱이 의심되는 사진을 첨부해주세요\n(문자, 이메일, 카카오톡 캡처 이미지 등)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            const ImagePickerWidget(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 분석 로직 연결
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // 홈/대화 등 네비게이션 전환 처리
        },
      ),
    );
  }
}
