import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/screens/screens/forgot_password.dart';
import 'package:insta_node_app/screens/screens/main_app.dart';
import 'package:insta_node_app/screens/screens/signup.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/text_form_input.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _accountController.dispose();
  }

  void _loginUser() async {
    try {
      // setState(() {
      //   _isLoading = true;
      // });
      final res = await AuthApi()
          .loginUser(
              _accountController.text, _passwordController.text
          );
      if(!mounted) return;
      Provider.of<AuthProvider>(context, listen: false).setAuth(res);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainAppScreen()));
      // setState(() {
      //   _isLoading = false;
      // });
    } catch (err) {
      showSnackBar(context, 'Error', 'Email or password is incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ImageHelper.loadImageAsset(AssetHelper.icLogo,
                        height: 60, width: 60)),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormIntput(
                        controller: _accountController,
                        label: 'Username, email or phone number'),
                    const SizedBox(height: 12),
                    TextFormIntput(
                        controller: _passwordController, label: 'Password'),
                    const SizedBox(
                      height: 12,
                    ),
                    ButtonWidget(
                      isHasLoading: true,
                      text: 'Log in',
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      onPressed: _loginUser,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ButtonWidget(
                    text: 'Create new account',
                    backgroundColor: Colors.black,
                    textColor: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                    },
                    borderColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '☂ Winter',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
