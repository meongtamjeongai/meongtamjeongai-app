import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_detection/emergency_contact_card.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_handling_guide/handling_step_card.dart';

class PhishingHandlingGuideScreen extends StatelessWidget {
  const PhishingHandlingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('피해 대처 가이드'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HandlingStepCard(
            stepNumber: 1,
            title: '문자/앱 차단',
            description: '피싱 문자나 앱을 받았다면 즉시 차단하고 삭제하세요.',
          ),
          HandlingStepCard(
            stepNumber: 2,
            title: '계정 보호',
            description: '비밀번호를 변경하고 2단계 인증을 설정하세요.',
          ),
          HandlingStepCard(
            stepNumber: 3,
            title: '신고 접수',
            description: '사이버 수사대나 금융기관에 신고하세요.',
          ),
          SizedBox(height: 16),
          EmergencyContactCard(),
        ],
      ),
    );
  }
}
