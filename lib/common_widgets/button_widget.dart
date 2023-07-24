import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Function() onPressed;
  final bool? isHasLoading;
  const ButtonWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor = Colors.transparent,
    required this.onPressed,
    this.isHasLoading = false,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isLoading = false;

  void handleClickButton() async{
    if(widget.isHasLoading == true) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 500), () {});
      widget.onPressed();
      setState(() {
        _isLoading = false;
      });
    } else {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleClickButton,
      child: Container(
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
        child: _isLoading == true && widget.isHasLoading == true
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                    fontSize: 16,
                    color: widget.textColor,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
