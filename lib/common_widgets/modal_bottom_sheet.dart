import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void showModalBottomSheetCustom(
    BuildContext context, Widget child) {
  showModalBottomSheet<dynamic>(
      backgroundColor: HexColor('#121212'),
      // isDismissible: true,
      isScrollControlled: true,
      barrierColor:  Colors.white.withOpacity(.3),
      enableDrag: true,
      useSafeArea: true,
      showDragHandle: true,
      // elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      transitionAnimationController: AnimationController(
          vsync: Navigator.of(context),
          duration: const Duration(milliseconds: 200)),
      context: context,
      builder: (BuildContext context) {
        return child;
      });
}
