import 'package:flutter/material.dart';
import 'package:insta_node_app/recources/auth_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/auth/screens/signup_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _pageController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (page) {
        setState(() {
          _currentIndex = page;
        });
      },
      children: [
        SignUpLayout(
          controller: _fullNameController,
          text: 'What\'s your name',
          label: 'Full Name',
          backButtonPressed: navigationBackTapped,
          nextButtonPressed: () => navigationTapped(_currentIndex + 1),
        ),
        SignUpLayout(
          controller: _usernameController,
          text: 'Create a username',
          label: 'Username',
          description:
              'Add a username or use our suggestion. You can change this at any time.',
          backButtonPressed: navigationBackTapped,
          nextButtonPressed: () => navigationTapped(_currentIndex + 1),
        ),
        SignUpLayout(
          controller: _emailController,
          text: 'What\'s your email',
          label: 'Email',
          description:
              'Enter the email where you can be contacted. No one will see this on your profile.',
          backButtonPressed: navigationBackTapped,
          nextButtonPressed: () => navigationTapped(_currentIndex + 1),
        ),
        SignUpLayout(
          controller: _passwordController,
          text: 'Create a password',
          label: 'Password',
          description:
              'Create a passowrd with at least 6 letters or numbers.It should be something others can\'t guess.',
          backButtonPressed: navigationBackTapped,
          nextButtonPressed: signUpUser,
        ),
      ],
    );
  }

   void navigationBackTapped() {
    if (_currentIndex > 0) {
      _pageController.jumpToPage(_currentIndex - 1);
    } else {
      Navigator.pop(context);
    }
  }

  void signUpUser() async {
    try {
      final res = await AuthApi().registerUser(
          _fullNameController.text,
          _usernameController.text,
          _emailController.text,
          _passwordController.text);
      if (!mounted) return;
      if (res == 'Register successfully!') {
        Navigator.pop(context);
        showSnackBar(context, 'Success', res);
      } else {
        showSnackBar(context, 'Error', res);
      }
    } catch (err) {
      showSnackBar(context, 'Error', err.toString());
    }
  }

  void navigationTapped(int page) async {
    if (_currentIndex < 3) {
      if (page == 2) {
        final res = await AuthApi().checkUserName(_usernameController.text);
        if (res == 'OK') {
          _pageController.jumpToPage(page);
        } else {
          if (!mounted) return;
          showSnackBar(context, 'Error', res);
        }
      } else if (page == 3) {
        final res = await AuthApi().checkEmail(_emailController.text);
        if (res == 'OK') {
          _pageController.jumpToPage(page);
        } else {
          if (!mounted) return;
          showSnackBar(context, 'Error', res);
        }
      } else {
        _pageController.jumpToPage(page);
      }
    } else {
      signUpUser();
    }
  }
}
