import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/heart_balance_card.dart';
import '../widgets/menu_list_title.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 정보'),

        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.menu)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: const [
          ProfileHeader(),
          SizedBox(height: 20),
          HeartBalanceCard(),
          SizedBox(height: 30),
          MenuListTile(icon: Icons.help_outline, label: '자주 묻는 질문'),
          SizedBox(height: 10),
          MenuListTile(icon: Icons.campaign_outlined, label: '공지사항'),
          SizedBox(height: 10),
          MenuListTile(icon: Icons.privacy_tip_outlined, label: '개인정보 보호정책'),
          SizedBox(height: 10),
          MenuListTile(icon: Icons.description_outlined, label: '앱 이용약관'),
          SizedBox(height: 10),
          MenuListTile(icon: Icons.info_outline, label: '앱 정보'),
        ],
      ),
    );
  }
}
