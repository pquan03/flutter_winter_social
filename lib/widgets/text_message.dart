import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TextMessageWidget extends StatelessWidget {
  final Color color;
  final String text;
  const TextMessageWidget({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                HexColor('#bc1888').withRed(255),
                Colors.deepOrangeAccent,
                Colors.blueAccent,
                Colors.blueAccent,
                Colors.blueAccent,
                                Colors.blueAccent,
                                                Colors.blueAccent,
              ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
