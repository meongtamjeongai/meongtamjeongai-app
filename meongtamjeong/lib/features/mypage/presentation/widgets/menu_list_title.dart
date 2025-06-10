import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // ✅ 추가

  const MenuListTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap, // ✅ 추가
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue, size: 30),
          title: Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.black87),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap, // ✅ 연결
        ),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}
