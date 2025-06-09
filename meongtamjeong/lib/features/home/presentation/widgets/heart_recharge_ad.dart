import 'package:flutter/widgets.dart';

class HeartRechargeAd extends StatelessWidget {
  const HeartRechargeAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/backgrounds/banner_placeholder.png',
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
