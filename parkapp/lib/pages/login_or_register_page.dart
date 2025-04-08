import 'package:flutter/material.dart';
import 'package:parkapp/pages/login_page.dart';
import 'package:parkapp/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void toggleLoginReg() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: toggleLoginReg);
    } else {
      return RegisterPage(onTap: toggleLoginReg);
    }
  }
}
