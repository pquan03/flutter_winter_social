import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final String text;
  final Function onClick;

  const CircularButton(
      {Key? key,
        required this.width,
        required this.height,
        required this.color,
        required this.icon,
        required this.onClick,
        required this.text,
        })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 5,),
            Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}