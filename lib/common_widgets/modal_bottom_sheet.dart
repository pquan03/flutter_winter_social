import 'package:flutter/material.dart';
import 'package:insta_node_app/views/keep_alive_screen.dart';

class Config {
  final bool? useSafeArea;
  final bool? showDragHandle;
  final Color? barrierColor;

  const Config({this.showDragHandle, this.barrierColor, this.useSafeArea});
}

void showModalBottomSheetCustom(BuildContext context, Widget child,
    [Config? config]) {
  showModalBottomSheet<dynamic>(
      // isDismissible: true,
      barrierColor: config?.barrierColor ?? Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: config?.useSafeArea ?? true,
      showDragHandle: config?.showDragHandle ?? true,
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
