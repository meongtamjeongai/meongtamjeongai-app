import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/image_picker_widget.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/safety_guide_card.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class DetectionMainScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const DetectionMainScreen({super.key, this.onBack});

  @override
  State<DetectionMainScreen> createState() => _DetectionMainScreenState();
}

class _DetectionMainScreenState extends State<DetectionMainScreen> {
  File? selectedImage;
  bool isLoading = false;

  void _onImageChanged(File image) {
    setState(() {
      selectedImage = image;
    });
  }

  Future<void> _handleInvestigation(BuildContext context) async {
    if (selectedImage == null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('⚠️ 이미지가 필요합니다'),
              content: const Text('이미지를 올려주셔야 피싱 조사가 가능합니다!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await locator<ApiService>().analyzePhishingImage(
        selectedImage!,
      );
      if (result == null) throw Exception('분석 결과를 가져올 수 없습니다.');

      print('📥 result: ${result.phishingScore}, reason: ${result.reason}');

      if (context.mounted) {
        context.push('/result', extra: result);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❗ 분석 중 오류 발생: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCharacter =
        context.watch<CharacterProvider>().selectedCharacter;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          '피싱 의심 조사',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/main', extra: {'index': 1});
          }, // ✅ 전달된 뒤로가기 콜백
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/characters/example_meong.png',
                  height: 130,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '“의심스러운 메시지를 받으셨나요? \n직접 클릭하는건 위험해요🚨 \n캡처해서 올려주세요!\n안전하게 분석해드릴게요.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.6,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ImagePickerWidget(onImageChanged: _onImageChanged),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed:
                        isLoading ? null : () => _handleInvestigation(context),
                    icon: const Icon(Icons.shield, color: Colors.white),
                    label: const Text(
                      '피싱 조사하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '이미지 분석 중입니다...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
