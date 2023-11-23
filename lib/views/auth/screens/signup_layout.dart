import 'package:flutter/material.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/text_form_input.dart';
import 'package:insta_node_app/views/auth/screens/loading_shimmer_sign_up.dart';

import '../../../constants/dimension.dart';

class SignUpLayout extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final String? description;
  final String? label;
  final Function() nextButtonPressed;
  final Function() backButtonPressed;
  const SignUpLayout({
    super.key,
    required this.controller,
    this.text,
    this.description,
    this.label,
    required this.nextButtonPressed,
    required this.backButtonPressed,
  });

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  bool _isLoadingShimmer = true;

  @override
  void initState() {
    super.initState();
    _loadShimmer();
  }

  void _loadShimmer() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _isLoadingShimmer = false;
      });
    });
  }

  void handleClickNextButton() async {
    if (!widget.controller.text.isNotEmpty) {
      if (!mounted) return;
      showSnackBar(context, 'Error', '${widget.label} cannot be empty');
    } else {
      widget.nextButtonPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingShimmer
        ? LoadingSignUp()
        : Scaffold(
            body: Container(
              padding: const EdgeInsets.all(16),
              decoration:
                  BoxDecoration(gradient: Gradients.defaultGradientBackground),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.text!,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  widget.description != null
                      ? Container(
                          padding: const EdgeInsets.only(top: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.description!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ))
                      : Container(),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormIntput(
                    controller: widget.controller,
                    label: widget.label!,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ButtonWidget(
                    text: widget.label == 'Password' ? 'Sign Up' : 'Next',
                    backgroundColor: Colors.blue,
                    onPressed: handleClickNextButton,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Text(
                        'Already have an account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
