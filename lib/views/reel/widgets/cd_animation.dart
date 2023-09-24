import 'package:flutter/widgets.dart';

class CdAnimationWidget extends StatefulWidget {
  const CdAnimationWidget({super.key, required this.child});
  final Widget child;

  @override
  State<CdAnimationWidget> createState() => _CdAnimationWidgetState();
}

class _CdAnimationWidgetState extends State<CdAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.repeat();
      }
      _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: _animation.value,
      duration: const Duration(seconds: 10),
      child: widget.child,
    );
  }
}
