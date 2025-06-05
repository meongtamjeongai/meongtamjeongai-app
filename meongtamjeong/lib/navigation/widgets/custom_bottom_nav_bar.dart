import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = 24.0;
    const selectedColor = Colors.blue;
    const unselectedColor = Colors.grey;

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final isSelected = index == currentIndex;

          final icon =
              [
                Icons.home_outlined,
                Icons.shield_outlined,
                Icons.chat_bubble_outline,
                Icons.history_outlined,
                Icons.person_outline,
              ][index];

          final activeIcon =
              [
                Icons.home,
                Icons.shield,
                Icons.chat_bubble,
                Icons.history,
                Icons.person,
              ][index];

          final label = ['홈', '피싱방지', '대화하기', '대화보기', '내 정보'][index];

          final color = isSelected ? selectedColor : unselectedColor;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 2)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activeIcon,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    )
                  else
                    Icon(
                      isSelected ? activeIcon : icon,
                      color: color,
                      size: iconSize,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
