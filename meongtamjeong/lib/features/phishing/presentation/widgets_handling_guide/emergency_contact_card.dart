import 'package:flutter/material.dart';

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📞 긴급 신고처',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('• 경찰청 사이버수사대: ☎ 182'),
            Text('• 금융감독원: ☎ 1332'),
            Text('• 각 은행 고객센터 또는 앱 통해 신고 가능'),
          ],
        ),
      ),
    );
  }
}
