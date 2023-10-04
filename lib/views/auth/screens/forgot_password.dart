import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/text_form_input.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  int _currentIndex = 0;
  var user = {};
  final PageController _pageController = PageController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _accountController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      children: [screen1(), screen2()],
    );
  }

  Widget screen2() {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                // instagram gradient color
                Color(0xFF833AB4).withOpacity(.2),
                Color(0xFFFD1D1D).withOpacity(.1),
                Color(0xFFFCAF45).withOpacity(.2),
              ])),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    if (_currentIndex > 0) {
                      navigationTapped(_currentIndex - 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user['avatar'] ?? ''),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      user['username'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Reset passowrd to be can log in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextFormIntput(
                      controller: _newPasswordController,
                      label: 'New password'),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormIntput(
                    controller: _confirmPasswordController,
                    label: 'Confirm password',
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: resetPassword,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, right: 10, left: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24),
            ),
            width: double.infinity,
            child: Text(
              'Reset password',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget screen1() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
              // instagram gradient color
              Color(0xFF833AB4).withOpacity(.2),
              Color(0xFFFD1D1D).withOpacity(.1),
              Color(0xFFFCAF45).withOpacity(.2),
            ])),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter your username, email or phone number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )),
            const SizedBox(
              height: 16,
            ),
            TextFormIntput(
              controller: _accountController,
              label: 'Username, email or phone number',
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonWidget(
              isLoading: _isLoading,
              text: 'Find Account',
              backgroundColor: Colors.blue,
              onPressed: findAccont,
            )
          ],
        ),
      ),
    );
  }

  void navigationTapped(int page) async {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  void findAccont() async {
    setState(() {
      _isLoading = true;
    });
    final res = await AuthApi().forgotPassword(_accountController.text);
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (res is String) {
        showSnackBar(context, 'Error', res);
        setState(() {
          _isLoading = false;
        });
      } else {
        navigationTapped(_currentIndex + 1);
        setState(() {
          user = res;
          _isLoading = false;
        });
      }
    });
  }

  void resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showSnackBar(context, 'Error', 'Password and confirm password not match');
    }
    final res = await AuthApi()
        .resetPassword(user['_id'] ?? '', _newPasswordController.text);
    if (!mounted) return;
    if (res == 'OK') {
      showSnackBar(context, 'Success', 'Reset password successfully');
      Navigator.pop(context);
    } else {
      showSnackBar(context, 'Error', res);
    }
  }
}
