import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const MenuListTile({super.key, required this.icon, required this.label});

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
          onTap: () {
            // TODO: GoRouter 연결
          },
        ),
        SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}
