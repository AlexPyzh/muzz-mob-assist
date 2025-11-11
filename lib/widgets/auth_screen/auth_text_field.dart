import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.hintText,
    required this.isObscured,
    required this.keboardType,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isObscured;
  final TextInputType keboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(style: const TextStyle(color: MuzzTheme.inputTextColor), controller: controller,
        obscureText: isObscured,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          fillColor: MuzzTheme.inputFillColor,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: MuzzTheme.inputHintColor),
        ),
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        keyboardType: keboardType,
      ),
    );
  }
}
