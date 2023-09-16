import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final double size;
  const CustomBackButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, size: size,),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}