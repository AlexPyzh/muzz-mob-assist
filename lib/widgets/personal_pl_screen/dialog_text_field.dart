import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:flutter/material.dart';

class DialogTextField extends StatelessWidget {
  const DialogTextField({
    required this.controller,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(color: MuzzTheme.inputTextColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: MuzzTheme.inputHintColor),
      ),
    );
  }
}
