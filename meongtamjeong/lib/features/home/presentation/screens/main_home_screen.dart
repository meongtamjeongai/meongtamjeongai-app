import 'package:flutter/material.dart';
import '../widgets/heart_recharge_ad.dart';
import '../widgets/main_features_grid.dart';
import '../widgets/character_selection_scroll.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 10),
              HeartRechargeAd(),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '전체 기능보기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              SizedBox(height: 10),

              MainFeaturesGrid(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '다른 명탐정과 대화 시작하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 10),

              CharacterSelectionScroll(),

              // SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
