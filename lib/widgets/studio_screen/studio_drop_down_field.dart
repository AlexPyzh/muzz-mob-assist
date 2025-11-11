import 'package:flutter/material.dart';

class StudioDropDownField extends StatefulWidget {
  const StudioDropDownField({
    required this.value,
    required this.values,
    required this.hintText,
    super.key,
  });

  final String value;
  final List<String> values;
  final String hintText;

  @override
  State<StudioDropDownField> createState() => _StudioDropDownFieldState();
}

class _StudioDropDownFieldState extends State<StudioDropDownField> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: DropdownButtonFormField(
        items: widget.values.map(
          (String category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Colors.grey,
                  ),
                  Text(
                    category,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: (newValue) {
          setState(() => value = newValue.toString());
        },
        value: value,
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
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
