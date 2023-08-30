import 'package:flutter/material.dart';

class TextMessageWidget extends StatelessWidget {
  final Color color;
  final String text;
  const TextMessageWidget({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
          ),
      ),
    );
  }
}
