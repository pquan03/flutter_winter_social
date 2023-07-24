import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/button_widget.dart';
import 'package:insta_node_app/common_widgets/text_form_input.dart';
import 'package:insta_node_app/models/auth.dart';
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

  @override
  void dispose() {
    super.dispose();
    _accountController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) async {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 200), curve: Curves.fastLinearToSlowEaseIn);
  }

  void findAccont() async {
    final res = await AuthApi().forgotPassword(_accountController.text);
    if (!mounted) return;
    if (res is String) {
      showSnackBar(context, 'Error', res);
    } else {
      navigationTapped(_currentIndex + 1);
      setState(() {
        user = res;
      });
    }
  }

  void resetPassword() async {
    if(_newPasswordController.text != _confirmPasswordController.text) {
      showSnackBar(context, 'Error', 'Password and confirm password not match');
    }
    final res = await AuthApi().resetPassword(user['_id'] ?? '', _newPasswordController.text);
    if(!mounted) return;
    if(res == 'OK') {
      showSnackBar(context, 'Success', 'Reset password successfully');
      Navigator.pop(context);
    } else {
      showSnackBar(context, 'Error', res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PageView(
      controller: _pageController,
      onPageChanged: (value){
        setState(() {
          _currentIndex = value;
        });
      },
      children: [
        screen1(),
        screen2()
      ],
    ));
  }

  Widget screen2() {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: GestureDetector(
                onTap: () {
                  if(_currentIndex > 0) {
                    navigationTapped(_currentIndex - 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ))),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Reset passowrd to be can log in',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextFormIntput(controller: _newPasswordController, label: 'New password'),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormIntput(controller: _confirmPasswordController, label: 'Confirm password',),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: resetPassword,
          child: Container(
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
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find Your Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter your username, email or phone number',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
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
              isHasLoading: true,
              text: 'Find Account',
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              onPressed: findAccont,
            )
          ],
        ),
      ),
    );
  }
}
