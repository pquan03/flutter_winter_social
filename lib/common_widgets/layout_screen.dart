import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/size.dart';

class LayoutScreen extends StatefulWidget {
  final bool isClose;
  final String? title;
  final Widget? child;
  final Function? onPressed;
  final List<Widget>? action;
  final Widget? floatingActionButton;
  const LayoutScreen(
      {super.key,
      required this.title,
      required this.child,
      this.action,
      this.isClose = false,
      this.onPressed,
      this.floatingActionButton});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        toolbarHeight: TSizes.appBarHeight,
        actions: widget.action != null ? [...widget.action!] : null,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                widget.isClose ? Icons.close : Icons.arrow_back,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      body: widget.child,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
