import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/screens/login_screen.dart';
import 'package:muzzbirzha_mobile/screens/register_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: toggleScreens,
      );
    } else {
      return RegisterScreen(
        onTap: toggleScreens,
      );
    }
  }
}
