import 'package:flutter/material.dart';

class StudioCategoryCheckbox extends StatefulWidget {
  const StudioCategoryCheckbox({
    required this.categoryName,
    required this.onToggleCategory,
    super.key,
  });

  final String categoryName;
  final Function(String, bool) onToggleCategory;

  @override
  State<StudioCategoryCheckbox> createState() => _StudioCategoryCheckboxState();
}

class _StudioCategoryCheckboxState extends State<StudioCategoryCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.white70, width: 2.0),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 5,
            offset: const Offset(4, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 4,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.categoryName,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                  activeColor: Colors.white54,
                  value: isChecked,
                  onChanged: (value) {
                    setState(
                      () {
                        isChecked = value!;
                        widget.onToggleCategory(widget.categoryName, isChecked);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
