import 'package:flutter/material.dart';

class Dimensions {
  // padding
  static const double dPaddingSmall = 8.0;
  static const double dPaddingMedium = 16.0;
  static const double dPaddingLarge = 24.0;
}

class Gradients {
  static Gradient defaultGradientBackground = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF833AB4).withOpacity(.2),
        Color(0xFFFD1D1D).withOpacity(.1),
        Color(0xFFFCAF45).withOpacity(.2),
      ]);
}
