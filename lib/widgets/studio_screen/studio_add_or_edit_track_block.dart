import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';

class StudioAddOrEditTrackBlock extends StatefulWidget {
  StudioAddOrEditTrackBlock({
    super.key,
    required this.trackIndex,
    required this.trackOrderController,
    required this.nameController,
    required this.aboutController,
    required this.localFilePathController,
    required this.priceController,
    required this.percentForSaleController,
    required this.onRemoveTrack,
    required this.onTrackOrderChanged,
    required this.shouldBeCreated,
    required this.shouldBeUpdated,
    this.yearController,
    this.track,
  });

  int trackIndex;
  final TextEditingController trackOrderController;
  final TextEditingController nameController;
  final TextEditingController aboutController;
  final TextEditingController localFilePathController;
  final TextEditingController priceController;
  final TextEditingController percentForSaleController;
  TextEditingController? yearController;
  void Function() onTrackOrderChanged;
  void Function(int trackNumber) onRemoveTrack;
  Track? track;
  bool shouldBeCreated = false;
  bool shouldBeUpdated = false;
  bool imageFileShouldBeMoved = false;
  bool muzzFileShouldBeMoved = false;
  bool muzzFileShouldBeReplaced = false;

  @override
  State<StudioAddOrEditTrackBlock> createState() =>
      _StudioAddOrEditTrackBlockState();

  void markShouldBeUpdated() {
    if (!shouldBeCreated) {
      shouldBeUpdated = true;
    }
  }
}

class _StudioAddOrEditTrackBlockState extends State<StudioAddOrEditTrackBlock> {
  Uint8List? _imageBytes;
  String? _imagePath;
  Uint8List? _muzFileBytes;
  String? _muzFileLocalPath;

  // void setImageBytesAndPath(Uint8List? imageBytes, String? imagePath) {
  //   _imageBytes = imageBytes;
  //   _imagePath = imagePath;
  // }

  void setMuzFileBytesAndPath(Uint8List? imageBytes, String? imagePath) {
    _muzFileBytes = imageBytes;
    _muzFileLocalPath = imagePath;

    if (!widget.shouldBeCreated) {
      widget.muzzFileShouldBeReplaced = true;
      widget.muzzFileShouldBeMoved = false;
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'ogg', 'wav', 'flac'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          widget.localFilePathController.text = file.path ?? '';
        });
        setMuzFileBytesAndPath(file.bytes, file.path);
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.sizeOf(context).width / 2 - mainLeftMargin;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StudioTextField(
              controller: widget.trackOrderController,
              hintText: "#",
              keyboardType: TextInputType.number,
              maxLines: 1,
              width: 40,
              onChanged: widget.onTrackOrderChanged,
            ),
            const SizedBox(width: 8),
            const Text(
              "track",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        StudioTextField(
          controller: widget.nameController,
          hintText: "Name",
          keyboardType: TextInputType.name,
          maxLines: 1,
          onChanged: widget.markShouldBeUpdated,
        ),
        const SizedBox(height: 20),
        if (widget.yearController != null)
          Column(
            children: [
              StudioTextField(
                controller: widget.yearController!,
                hintText: "Year",
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: widget.markShouldBeUpdated,
              ),
              const SizedBox(height: 20),
            ],
          ),
        StudioTextField(
          controller: widget.aboutController,
          hintText: "About",
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          onChanged: widget.markShouldBeUpdated,
        ),
        const SizedBox(height: 20),
        // ImageUploader(
        //   onGetImageBytesAndPath: setImageBytesAndPath,
        // ),
        // const SizedBox(height: 20),
        _StudioFilePathField(
          controller: widget.localFilePathController,
          onTap: () => _pickAudioFile(),
          hintText: "Tap to choose audio file",
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StudioTextField(
              controller: widget.priceController,
              hintText: "Price, USD",
              keyboardType: TextInputType.number,
              maxLines: 1,
              width: halfOfScreen,
              enabled: widget.track?.finInfo?.price == null ||
                  widget.track!.finInfo?.price! == 0,
            ),
            const Spacer(),
            StudioTextField(
              controller: widget.percentForSaleController,
              hintText: "Percent for sale",
              keyboardType: TextInputType.number,
              maxLines: 1,
              width: halfOfScreen,
              enabled: widget.track?.finInfo?.percentForSale == null ||
                  widget.track!.finInfo!.percentForSale == 0,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StudioButtonBase(
              caption: "Remove track",
              backgroundColor: Colors.grey,
              onPressed: () {
                widget.onRemoveTrack(widget.trackIndex);
              },
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _StudioFilePathField extends StatefulWidget {
  const _StudioFilePathField({
    required this.controller,
    required this.onTap,
    required this.hintText,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final String hintText;

  @override
  State<_StudioFilePathField> createState() => _StudioFilePathFieldState();
}

class _StudioFilePathFieldState extends State<_StudioFilePathField> {
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
