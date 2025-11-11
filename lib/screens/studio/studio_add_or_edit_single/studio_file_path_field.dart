import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class StudioFilePathField extends StatefulWidget {
  const StudioFilePathField({
    super.key,
    required this.controller,
    required this.onTap,
    required this.hintText,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final String hintText;

  @override
  State<StudioFilePathField> createState() => _StudioFilePathFieldState();
}

class _StudioFilePathFieldState extends State<StudioFilePathField> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // With reverse: true, the scroll starts from the right (filename visible)
    // So we don't need to scroll - it's already showing the filename by default
    // But we can reset scroll position to ensure filename is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        // Reset to start position (which shows the end/filename due to reverse: true)
        _scrollController.jumpTo(0);
      }
    });
  }

  String _getDisplayText() {
    if (widget.controller.text.isEmpty) {
      return widget.hintText;
    }

    // Return full path
    return widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _getDisplayText();
    final isHintText = widget.controller.text.isEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(MuzzTheme.inputRadius),
        child: Container(
          width: double.infinity,
          padding: MuzzTheme.inputPadding,
          decoration: BoxDecoration(
            color: MuzzTheme.inputFillColor,
            borderRadius: BorderRadius.circular(MuzzTheme.inputRadius),
            border: Border.all(color: Colors.transparent),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate text width to determine if it fits
              final textStyle = TextStyle(
                color: isHintText
                    ? MuzzTheme.inputHintColor
                    : MuzzTheme.inputTextColor,
                fontSize: 18,
                height: 1.2,
              );

              final textPainter = TextPainter(
                text: TextSpan(text: displayText, style: textStyle),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();

              final textWidth = textPainter.width;
              final availableWidth = constraints.maxWidth -
                  (isHintText ? 0 : 35); // Space for "..."
              final textFits = textWidth <= availableWidth;

              return Stack(
                alignment:
                    textFits ? Alignment.centerLeft : Alignment.centerRight,
                children: [
                  // Scrollable text
                  Padding(
                    padding: EdgeInsets.only(
                      left: textFits
                          ? 0
                          : (isHintText ? 0 : 35), // Padding for "..."
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      reverse: !textFits, // Reverse only if text doesn't fit
                      child: Text(
                        displayText,
                        textAlign: textFits ? TextAlign.left : TextAlign.right,
                        maxLines: 1,
                        style: textStyle,
                      ),
                    ),
                  ),
                  // Ellipsis at the left (only if text doesn't fit)
                  if (!isHintText && !textFits)
                    Positioned(
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              MuzzTheme.inputFillColor,
                              MuzzTheme.inputFillColor.withOpacity(0.0),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '...',
                          style: TextStyle(
                            color: MuzzTheme.inputTextColor,
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
