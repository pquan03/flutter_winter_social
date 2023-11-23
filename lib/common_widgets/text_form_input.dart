import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/dimension.dart';

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
  late FocusNode _focusNode;
  bool _isShowEye = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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
    return Container(
      padding: const EdgeInsets.all(Dimensions.dPaddingSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: _focusNode.hasFocus ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.label} cannot be empty';
          }
          return null;
        },
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.label.contains('password') ||
                widget.label.contains('Password')
            ? _obscureText
            : false,
        style: const TextStyle(fontWeight: FontWeight.w500),
        cursorColor: Colors.green,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          label: Text(widget.label),
          filled: true,
          border: InputBorder.none,
          fillColor: Colors.transparent,
          suffixIcon: _isShowEye && widget.label.contains('Password')
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
      ),
    );
  }
}
