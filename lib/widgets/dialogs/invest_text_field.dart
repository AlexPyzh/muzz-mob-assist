import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InvestTextField extends StatefulWidget {
  InvestTextField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.maxLines,
    required this.maxAmount,
    required this.canInvest,
    this.width,
    this.enabled,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final double maxAmount;
  double? width;
  bool? enabled;
  void Function()? onChanged;
  void Function(bool) canInvest;

  @override
  State<InvestTextField> createState() => _InvestTextFieldState();
}

class _InvestTextFieldState extends State<InvestTextField> {
  String errorMessage = "";
  bool displayError = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(validateValue);
  }

  void validateValue() {
    if (widget.controller.text == "") {
      errorMessage = "";
      displayError = false;
      widget.canInvest(false);
      setState(() {});
      return;
    }

    var numberVaue = double.tryParse(widget.controller.text.trim());

    if (numberVaue == null) {
      errorMessage = "Please enter a number";
      displayError = true;
      widget.canInvest(false);
      setState(() {});
      return;
    }

    if (numberVaue == 0) {
      errorMessage = "Zero is too small";
      displayError = true;
      widget.canInvest(false);
      setState(() {});
      return;
    }

    if (numberVaue > widget.maxAmount) {
      errorMessage = "Maximum is ${widget.maxAmount}";
      displayError = true;
      widget.canInvest(false);
      setState(() {});
      return;
    }

    errorMessage = "";
    displayError = false;
    widget.canInvest(true);
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: TextField(style: const TextStyle(color: Colors.black), 
        controller: widget.controller,
        enabled: widget.enabled ?? true,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!();
          }
        },
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
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: MuzzTheme.inputHintColor),
          errorText: displayError ? errorMessage : "",
          errorStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
          focusedErrorBorder: displayError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
        ),
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
