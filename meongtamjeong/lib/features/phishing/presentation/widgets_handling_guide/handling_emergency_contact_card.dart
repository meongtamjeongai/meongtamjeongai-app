import 'package:flutter/material.dart';

class HandlingEmergencyContactCard extends StatelessWidget {
  const HandlingEmergencyContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📞 긴급 신고처',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            Text(
              '• 경찰청 사이버수사대: ☎ 182',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '• 금융감독원: ☎ 1332',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '• 각 은행 고객센터 또는 앱을 통해 신고할 수 있어요.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
