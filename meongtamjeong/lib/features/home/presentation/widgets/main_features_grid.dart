import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class MainFeaturesGrid extends StatelessWidget {
  const MainFeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCharacter =
        context.watch<CharacterProvider>().selectedCharacter;
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.report_problem_outlined,
        'label': '피싱 의심 조사',
        'index': 1,
        'sub': 'investigation',
      },
      {
        'icon': Icons.smart_toy_outlined,
        'label': '피싱 시뮬레이션',
        'index': 1,
        'sub': 'simulation',
      },
      {
        'icon': Icons.description,
        'label': '피해 대처 가이드',
        'index': 1,
        'sub': 'guide',
      },
      {'icon': Icons.chat_outlined, 'label': '대화하기', 'index': 2},
      {'icon': Icons.history_outlined, 'label': '지난 대화보기', 'index': 3},
      {'icon': Icons.person_outline, 'label': '내 정보', 'index': 4},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final feature = features[index];
          return InkWell(
            onTap: () {
              final index = feature['index'] as int;
              final sub = feature['sub'] as String?;

              context.goNamed('main', extra: {'index': index, 'sub': sub});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  feature['icon'] as IconData,
                  size: 35,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 6),
                Text(
                  feature['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
