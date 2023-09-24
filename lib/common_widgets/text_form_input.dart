import 'package:flutter/material.dart';

class TextFormIntput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const TextFormIntput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<TextFormIntput> createState() => _TextFormIntputState();
}

class _TextFormIntputState extends State<TextFormIntput> {
  final FocusNode _focusNode = FocusNode();
  bool _isShowEye = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isShowEye = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(() {});
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.label} cannot be empty';
        }
        return null;
      },
      focusNode:
          widget.label.contains('password') || widget.label.contains('Password')
              ? _focusNode
              : null,
      controller: widget.controller,
      obscureText:
          widget.label.contains('password') || widget.label.contains('Password')
              ? _obscureText
              : false,
      style: const TextStyle(fontWeight: FontWeight.w500),
      cursorColor: Colors.green,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        label: Text(widget.label),
        filled: true,
        suffixIcon: _isShowEye
            ? _obscureText
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      Icons.visibility_off,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      Icons.visibility,
                    ),
                  )
            : null,
      ),
    );
  }
}
