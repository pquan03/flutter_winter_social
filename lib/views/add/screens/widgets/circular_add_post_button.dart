import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final String? text;
  final Function onClick;

  const CircularButton({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.icon,
    required this.onClick,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            if (text != null)
              SizedBox(
                width: 5,
              ),
            text == null
                ? SizedBox.shrink()
                : Text(
                    text!,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
          ],
        ),
      ),
    );
  }
}
