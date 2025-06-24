import 'package:flutter/material.dart';

class HandlingEmergencyContactCard extends StatelessWidget {
  const HandlingEmergencyContactCard({super.key});

  static const Color borderColor = Color.fromARGB(
    255,
    250,
    153,
    148,
  ); // 연한 붉은 테두리

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: borderColor, size: 26),
              SizedBox(width: 8),
              Text(
                '긴급 신고처',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 경찰청
          Row(
            children: const [
              // Icon(Icons.phone, color: Colors.grey, size: 20),
              Expanded(
                child: Text(
                  '경찰청 사이버수사대: 📞 182',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 금융감독원
          Row(
            children: const [
              Expanded(
                child: Text(
                  '금융감독원: 📞 1332',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // KISA
          Row(
            children: const [
              Expanded(
                child: Text(
                  'KISA 인터넷침해대응센터: 📞 118',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 안내 문구
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '각 은행 고객센터 또는 앱을 통해 신고할 수 있어요.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
