import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:flutter/material.dart';

class StudioTextField extends StatelessWidget {
  StudioTextField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.maxLines,
    this.width,
    this.enabled,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final double? width;
  final bool? enabled;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: MuzzTheme.inputTextColor,
      fontSize: 18,
      height: 1.2,
    );

    final textField = TextField(
      controller: controller,
      onChanged: (value) => onChanged?.call(),
      maxLines: maxLines,
      enabled: enabled ?? true,
      style: textStyle,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: MuzzTheme.inputPadding,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius:
              BorderRadius.all(Radius.circular(MuzzTheme.inputRadius)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MuzzTheme.inputBorderColor),
          borderRadius:
              BorderRadius.all(Radius.circular(MuzzTheme.inputRadius)),
        ),
        fillColor: MuzzTheme.inputFillColor,
        filled: true,
        hintText: '',
        hintStyle: TextStyle(color: MuzzTheme.inputHintColor, fontSize: 18),
      ).copyWith(
        hintText: hintText,
      ),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: keyboardType,
    );

    // If width is specified, wrap in a SizedBox, otherwise return the TextField directly
    if (width != null) {
      return SizedBox(
        width: width,
        child: textField,
      );
    }

    return textField;
  }
}
