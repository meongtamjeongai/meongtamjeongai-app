import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeartBalanceCard extends StatelessWidget {
  const HeartBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final heartCount = 0;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '보유하트 $heartCount개',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed('heart-recharge'),
            child: Row(
              children: const [
                Text('구매하기', style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
