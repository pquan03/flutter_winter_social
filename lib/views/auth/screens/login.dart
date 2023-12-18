import 'package:flutter/material.dart';
import 'package:insta_node_app/constants/size.dart';
import 'package:insta_node_app/utils/helpers/helper_functions.dart';
import 'package:insta_node_app/utils/helpers/image_helper.dart';
import 'package:insta_node_app/utils/helpers/asset_helper.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/text_form_input.dart';
import 'package:insta_node_app/views/auth/screens/forgot_password.dart';
import 'package:insta_node_app/views/navigation_view.dart';
import 'package:insta_node_app/views/auth/screens/signup.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _accountController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    _accountController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _accountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.12),
                alignment: Alignment.bottomCenter,
                child: ImageHelper.loadImageAsset(AssetHelper.icLogo,
                    height: 60, width: 60)),
            Expanded(
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
                    isLoading: _isLoading,
                    text: 'Log in',
                    backgroundColor: Colors.blue,
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
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isKeyboardShowing
                ? SizedBox.shrink()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen())),
                              child: const Text("Create new account")),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '☂ Winter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await AuthApi()
          .loginUser(_accountController.text, _passwordController.text);
      if (!mounted) return;
      Provider.of<AuthProvider>(context, listen: false).setAuth(res);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainAppScreen()),
          (route) => false);
    } catch (err) {
      showSnackBar(context, 'Error', 'Email or password is incorrect');
    }
    setState(() {
      _isLoading = false;
    });
  }
}
