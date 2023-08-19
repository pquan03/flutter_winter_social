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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.label} cannot be empty';
          }
          return null;
        },
        focusNode: widget.label.contains('password') || widget.label.contains('Password') ? _focusNode : null,
        controller: widget.controller,
        obscureText: widget.label.contains('password') || widget.label.contains('Password') ? _obscureText : false,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          label: Text(widget.label),
          labelStyle:
              TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          floatingLabelStyle: TextStyle(
              color: Colors.white60, fontWeight: FontWeight.w500, fontSize: 18),
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
                          color: Colors.white,
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
                          color: Colors.white,
                        ),
                  )
              : null,
        ),
      ),
    );
  }
}
