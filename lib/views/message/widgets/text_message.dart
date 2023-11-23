import 'package:flutter/material.dart';

import '../../../constants/dimension.dart';

class TextMessageWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  const TextMessageWidget(
      {super.key,
      required this.backgroundColor,
      required this.textColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
      padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.dPaddingSmall),
      decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          )),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
