import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color? textColor;
  final Color borderColor;
  final Function() onPressed;
  final bool? isLoading;
  const ButtonWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.textColor,
    required this.onPressed,
    this.isLoading,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isLoading = false;
  void handleClickButton() async {
    if (widget.isLoading == null) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        widget.onPressed();
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? loadingContainer()
        : _isLoading
            ? loadingContainer()
            : GestureDetector(
                onTap: handleClickButton,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: widget.borderColor == Colors.transparent
                      ? BoxDecoration(
                          color: widget.backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                        )
                      : BoxDecoration(
                          color: widget.backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          border:
                              Border.all(color: widget.borderColor, width: 1),
                        ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        color: widget.textColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
  }

  Widget loadingContainer() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: widget.borderColor == Colors.transparent
          ? BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            )
          : BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              border: Border.all(color: widget.borderColor, width: 1),
            ),
      child: Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
