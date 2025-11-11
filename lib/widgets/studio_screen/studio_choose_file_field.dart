import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StudioChooseFileField extends StatelessWidget {
  const StudioChooseFileField({
    required this.controller,
    required this.hintText,
    required this.keboardType,
    required this.maxLines,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: keboardType,
    );
  }
}
