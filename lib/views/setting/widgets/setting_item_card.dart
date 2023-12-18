import 'package:flutter/material.dart';

import '../../../constants/dimension.dart';

class SettingItemCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function? onTap;
  const SettingItemCard(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.dPaddingMedium),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
