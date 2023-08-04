
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  final bool isClose;
  final String? title;
  final Widget? child;
  final Function? onPressed;
  final List<Widget>? action;
  const LayoutScreen({super.key, required this.title, required this.child , this.action, this.isClose = false, this.onPressed});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
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
                    widget.isClose ? Icons.close :
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
              ),
              const SizedBox(width: 16,),
              Text(
                widget.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: widget.child,
      ),
    );
  }
}