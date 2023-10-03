import 'package:flutter/material.dart';
import 'package:insta_node_app/views/keep_alive_screen.dart';

void showModalBottomSheetCustom(BuildContext context, Widget child) {
  showModalBottomSheet<dynamic>(
      // isDismissible: true,
      isScrollControlled: true,
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
        return KeepAlivePage(child: child);
      });
}
