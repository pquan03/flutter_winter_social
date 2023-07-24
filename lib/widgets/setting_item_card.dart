

import 'package:flutter/material.dart';

class SettingItemCard extends StatelessWidget {
  final Icon icon;
  final String title;
  const SettingItemCard({super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.transparent,
        child: Row(
          children: [
            icon,
            SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}