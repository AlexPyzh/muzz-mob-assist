import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';
import 'add_edit_single_helper.dart';
import 'dashed_border_painter.dart';
import 'studio_file_path_field.dart';

class StudioAddOrEditSingleScreen extends StatefulWidget {
  const StudioAddOrEditSingleScreen({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<StudioAddOrEditSingleScreen> createState() =>
      _StudioAddOrEditSingleScreenState();
}

class _StudioAddOrEditSingleScreenState
    extends State<StudioAddOrEditSingleScreen> {
  late final dynamic studioProvider;
  late final AddEditSingleHelper helper;

  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final aboutController = TextEditingController();
  final localFilePathController = TextEditingController();
  final priceController = TextEditingController();
  final percentForSaleController = TextEditingController();

  bool shouldBeCreated = false;
  bool shouldBeUpdated = false;
  bool muzFileShouldBeReplaced = false;
  bool muzFilesShouldBeMoved = false;
  bool imageFileShouldBeReplaced = false;
  bool imageFileShouldBeMoved = false;

  String? _imageLocalPath;
  String? _muzFileLocalPath;
  bool? _visible = false;
  bool _singleCreatedOrUpdated = false;

  @override
  void initState() {
    super.initState();
    studioProvider = Provider.of<StudioProvider>(context, listen: false);
    nameController.text = widget.track.name ?? "";
    yearController.text =
        widget.track.year == null ? "" : widget.track.year.toString();
    aboutController.text = widget.track.about ?? "";
    priceController.text =
        widget.track.finInfo?.price == null || widget.track.finInfo?.price == 0
            ? ""
            : widget.track.finInfo!.price!.toString();
    percentForSaleController.text =
        widget.track.finInfo?.percentForSale == null ||
                widget.track.finInfo?.percentForSale == 0
            ? ""
            : widget.track.finInfo!.percentForSale.toString();
    shouldBeCreated = widget.track.id == null;

    helper = AddEditSingleHelper(
      track: widget.track,
      nameController: nameController,
      yearController: yearController,
      aboutController: aboutController,
      localFilePathController: localFilePathController,
      priceController: priceController,
      percentForSaleController: percentForSaleController,
      studioProvider: studioProvider,
      getShouldBeCreated: () => shouldBeCreated,
      getShouldBeUpdated: () => shouldBeUpdated,
      getMuzFileShouldBeReplaced: () => muzFileShouldBeReplaced,
      getImageFileShouldBeReplaced: () => imageFileShouldBeReplaced,
      getImageLocalPath: () => _imageLocalPath,
      getMuzFileLocalPath: () => _muzFileLocalPath,
      getVisible: () => _visible ?? false,
      setSingleCreatedOrUpdated: (value) => _singleCreatedOrUpdated = value,
      onSetImageBytesAndPath: setImageBytesAndPath,
      onSetMuzFileBytesAndPath: setMuzFileBytesAndPath,
    );
  }

  void setImageBytesAndPath(Uint8List? imageBytes, String? imagePath) {
    setState(() {
      _imageLocalPath = imagePath;
    });
    if (!shouldBeCreated) {
      imageFileShouldBeReplaced = true;
      imageFileShouldBeMoved = false;
    }
  }

  void setMuzFileBytesAndPath(Uint8List? imageBytes, String? imagePath) {
    setState(() {
      _muzFileLocalPath = imagePath;
    });
    if (!shouldBeCreated) {
      muzFileShouldBeReplaced = true;
      muzFilesShouldBeMoved = false;
    }
  }

  void togglePublishCheckbox(bool publish) {
    _visible = publish;

    if (!shouldBeCreated) {
      shouldBeUpdated = true;
    }
  }

  void onNameChanged() {
    if (!shouldBeCreated) {
      shouldBeUpdated = true;
    }

    if (!shouldBeCreated && !imageFileShouldBeReplaced) {
      imageFileShouldBeMoved = true;
    }

    if (!shouldBeCreated && !muzFileShouldBeReplaced) {
      muzFilesShouldBeMoved = true;
    }
  }

  void markShouldBeUpdated() {
    if (!shouldBeCreated) {
      shouldBeUpdated = true;
    }
  }

  void createOrpdateSingle() async {
    if (!helper.fieldsValidated(context)) {
      return;
    }

    helper.showLoaderDialog(context);

    String? imageRemotePath;
    String? muzFileRemotePath;

    // image
    if (_imageLocalPath != null && _imageLocalPath != "") {
      if (shouldBeCreated) {
        imageRemotePath = await helper.uploadImage();
      } else {
        imageRemotePath = await helper.replaceImage();
      }
    } else if (imageFileShouldBeMoved) {
      imageRemotePath = await helper.moveImageFile();
    }

    // muz file and track
    if (shouldBeCreated) {
      muzFileRemotePath = await helper.uploadMuzFile();
      await helper.createTrack(imageRemotePath!, muzFileRemotePath);
    } else if (muzFilesShouldBeMoved) {
      muzFileRemotePath = await helper.moveMuzFile();
      await helper.updateTrack(imageRemotePath!, muzFileRemotePath);
    } else if (muzFileShouldBeReplaced) {
      muzFileRemotePath = await helper.replaceMuzFile();
    } else if (shouldBeUpdated) {
      await helper.updateTrack("", "");
    }

    await helper.updateStudioProvider();
    killDialogAndMoveBack();
    _singleCreatedOrUpdated = true;
  }

  @override
  Widget build(BuildContext context) {
    var halfOfScreen = MediaQuery.sizeOf(context).width / 2 - mainLeftMargin;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit single '${widget.track.name}'"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: mainLeftMargin),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StudioTextField(
                controller: nameController,
                hintText: "Name",
                keyboardType: TextInputType.name,
                maxLines: 1,
                onChanged: onNameChanged,
              ),
              const SizedBox(height: 20),
              StudioTextField(
                controller: yearController,
                hintText: "Year",
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: markShouldBeUpdated,
              ),
              const SizedBox(height: 20),
              StudioTextField(
                controller: aboutController,
                hintText: "About",
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                onChanged: markShouldBeUpdated,
              ),
              const SizedBox(height: 20),
              // Image picker styled per mock: dashed border, ash fill, larger yellow hint, icon; full-area tap handled by ImageUploader
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (kDebugMode) {
                          print('Image area clicked!');
                        }
                        helper.pickImage();
                      },
                      child: CustomPaint(
                        foregroundPainter: DashedBorderPainter(
                          radius: 16,
                          color: Colors.white38,
                          dashWidth: 8,
                          dashSpace: 6,
                          strokeWidth: 1.5,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            color: MuzzTheme.inputFillColor,
                            padding: const EdgeInsets.all(12),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Visual content showing current image or placeholder
                                _imageLocalPath != null
                                    ? // Show locally selected image
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.file(
                                          File(_imageLocalPath!),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : widget.track.imageUrl != null &&
                                            widget.track.imageUrl!.isNotEmpty
                                        ? // Show existing network image
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.network(
                                              widget.track.imageUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color:
                                                      MuzzTheme.inputFillColor,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            size: 44,
                                                            color:
                                                                Colors.white54),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          'Image not available',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          'Tap to choose new image',
                                                          style: TextStyle(
                                                            color: MuzzTheme
                                                                .accentColor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : // Show placeholder
                                        Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Tap to choose the image',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        MuzzTheme.accentColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Icon(Icons.image_outlined,
                                                    size: 44,
                                                    color: Colors.white24),
                                              ],
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              StudioFilePathField(
                controller: localFilePathController,
                onTap: () {
                  if (kDebugMode) {
                    print('Audio file button clicked!');
                  }
                  helper.pickMuzFile();
                },
                hintText: "Tap to choose audio file",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StudioTextField(
                    controller: priceController,
                    hintText: "Price, USD",
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    width: halfOfScreen,
                    enabled: widget.track.finInfo?.price == null ||
                        widget.track.finInfo?.price! == 0,
                  ),
                  const Spacer(),
                  StudioTextField(
                    controller: percentForSaleController,
                    hintText: "Percent for sale",
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    width: halfOfScreen,
                    enabled: widget.track.finInfo?.price == null ||
                        widget.track.finInfo?.percentForSale == 0,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Publish toggle (real switch) styled per mock
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white24, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Publish',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.95,
                          child: Switch(
                            value: _visible ?? false,
                            onChanged: (value) {
                              setState(() {
                                togglePublishCheckbox(value);
                              });
                            },
                            thumbColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.selected)
                                        ? MuzzTheme.toggleThumbOn
                                        : MuzzTheme.toggleThumbOff),
                            trackColor: MaterialStateProperty.resolveWith(
                                (states) => states
                                        .contains(MaterialState.selected)
                                    ? MuzzTheme.toggleTrackOn.withOpacity(0.55)
                                    : MuzzTheme.toggleTrackOff),
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    // Secondary (outlined) cancel
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: MuzzTheme.studioButtonHeight,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: MuzzTheme.studioSecondaryBorder,
                                  width: 2),
                              borderRadius: BorderRadius.circular(
                                  MuzzTheme.studioButtonRadius),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: MuzzTheme.studioSecondaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.01,
                              child: StudioButtonBase(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                caption: "Cancel",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Primary (filled) save
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: MuzzTheme.studioButtonHeight,
                            decoration: BoxDecoration(
                              color: MuzzTheme.studioPrimaryBg,
                              borderRadius: BorderRadius.circular(
                                  MuzzTheme.studioButtonRadius),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: MuzzTheme.studioPrimaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.01,
                              child: StudioButtonBase(
                                onPressed: () {
                                  createOrpdateSingle();
                                  if (_singleCreatedOrUpdated) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(shouldBeCreated
                                            ? 'Single created successfully'
                                            : 'Single updated successfully'),
                                      ),
                                    );
                                  }
                                },
                                caption: "Save",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void killDialogAndMoveBack() {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
  }
}
