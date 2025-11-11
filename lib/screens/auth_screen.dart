import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/screens/login_or_register_screen.dart';
import 'package:muzzbirzha_mobile/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (connext, value, child) {
      final isLoggedIn = value.isLoggedIn;

      return isLoggedIn ? const TabsScreen() : const LoginOrRegisterScreen();
      //return TabsScreen();
      //return LoginOrRegisterScreen();
    });
  }
}
