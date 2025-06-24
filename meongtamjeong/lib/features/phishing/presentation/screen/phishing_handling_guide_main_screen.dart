import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_handling_guide/handling_emergency_contact_card.dart';
import 'package:meongtamjeong/features/phishing/presentation/widgets_handling_guide/handling_step_card.dart';

class PhishingHandlingGuideScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const PhishingHandlingGuideScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '피해대처 안내',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ context.go 대신 상위 위젯(MainNavigationScreen)의 상태를 바꿔주는 콜백 호출
            onBack?.call();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HandlingStepCard(
            stepNumber: 1,
            title: '문자/이메일 차단',
            description: '문자나 이메일의 피싱의심 위험 점수가 \n높은 경우, 즉시 차단하고 삭제하세요.',
          ),
          HandlingStepCard(
            stepNumber: 2,
            title: '계정 보호',
            description: '유출된 계정(네이버, 카카오, 금융 등)의 \n비밀번호를 즉시 변경하세요',
          ),
          HandlingStepCard(
            stepNumber: 3,
            title: '신고 접수',
            description: '사이버 수사대나 금융기관에 \n피해사실을 신고하세요.',
          ),
          HandlingStepCard(
            stepNumber: 4,
            title: '피해 사실 보존',
            description: '문자/카톡 내용, 통화 기록, 입금내역 등을 \n스크린샷으로 저장 후 증거자료로 활용',
          ),
          HandlingStepCard(
            stepNumber: 5,
            title: '신분증 유출 시',
            description: '행정안전부 주민등록번호 변경 신청 \n고려 및 신분증 재발급',
          ),
          SizedBox(height: 16),
          HandlingEmergencyContactCard(),
        ],
      ),
    );
  }
}
