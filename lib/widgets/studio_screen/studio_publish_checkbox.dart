import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/components/neu_box.dart';

class StudioPublishCheckbox extends StatefulWidget {
  StudioPublishCheckbox({
    required this.onTogglePublish,
    this.checked,
    super.key,
  });

  final Function(bool) onTogglePublish;
  bool? checked;

  @override
  State<StudioPublishCheckbox> createState() => _StudioPublishCheckboxState();
}

class _StudioPublishCheckboxState extends State<StudioPublishCheckbox> {
  bool visible = false;

  @override
  void initState() {
    visible = widget.checked == null || widget.checked == false ? false : true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: NeuBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    activeColor: Colors.white70,
                    value: visible,
                    onChanged: (value) {
                      setState(
                        () {
                          visible = value!;
                          widget.onTogglePublish(visible);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Publish",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
