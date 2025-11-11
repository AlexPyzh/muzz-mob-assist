import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';

import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_album_tracks_button.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_or_edit_track_block.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';

import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';
import 'dashed_border_painter.dart';
import 'add_edit_album_helper.dart';

class StudioAddOrEditAlbumScreen extends StatefulWidget {
  const StudioAddOrEditAlbumScreen({
    super.key,
    required this.album,
  });

  final Album album;

  @override
  State<StudioAddOrEditAlbumScreen> createState() =>
      _StudioAddOrEditAlbumScreenState();
}

class _StudioAddOrEditAlbumScreenState
    extends State<StudioAddOrEditAlbumScreen> {
  late final dynamic studioProvider;
  final albumNameController = TextEditingController();
  final albumYearController = TextEditingController();
  final albumAboutController = TextEditingController();
  bool _albumVisible = false;
  bool _albumCreatedOrUpdated = false;
  bool albumShouldBeCreated = false;
  bool albumShouldBeUpdated = false;
  bool albumImageShouldBeReplaced = false;
  bool albumImageShouldBeMoved = false;
  bool muzFilesShouldBeMoved = false;

  // ignore: unused_field
  Uint8List? _albumImageBytes;
  String? _albumImageLocalPath;
  List<StudioAddOrEditTrackBlock> trackBlocks = [];
  late AddEditAlbumHelper _helper;

  @override
  void initState() {
    studioProvider = Provider.of<StudioProvider>(context, listen: false);
    if (widget.album.id == null) {
      albumShouldBeCreated = true;
    }

    _helper = AddEditAlbumHelper(
      album: widget.album,
      albumNameController: albumNameController,
      albumYearController: albumYearController,
      albumAboutController: albumAboutController,
      studioProvider: studioProvider,
      trackBlocks: trackBlocks,
      getAlbumShouldBeCreated: () => albumShouldBeCreated,
      getAlbumShouldBeUpdated: () => albumShouldBeUpdated,
      getAlbumImageShouldBeMoved: () => albumImageShouldBeMoved,
      getAlbumImageLocalPath: () => _albumImageLocalPath,
      getAlbumVisible: () => _albumVisible,
      setAlbumCreatedOrUpdated: (value) => _albumCreatedOrUpdated = value,
      onSetAlbumImageBytesAndPath: onSetAlbumImageBytesAndPath,
      addNewTrackFilePaths: addNewTrackFilePaths,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        albumNameController.text = widget.album.name ?? '';
        albumYearController.text = widget.album.year ?? '';
        albumAboutController.text = widget.album.description ?? "";
        _albumVisible = widget.album.visible ?? false;
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing album data: $e');
        }
      }
    });

    // albumNameController.text = widget.album.name ?? "";
    // albumYearController.text = widget.album.year ?? "";
    // albumAboutController.text = widget.album.description ?? "";
    // _albumVisible = widget.album.visible ?? false;

    if (widget.album.tracks != null) {
      int trackIndex = 0;

      trackBlocks = widget.album.tracks!.map(
        (t) {
          trackIndex++;
          return StudioAddOrEditTrackBlock(
            track: t,
            trackIndex: trackIndex,
            trackOrderController:
                TextEditingController(text: t.albumOrder.toString()),
            nameController: TextEditingController(text: t.name),
            aboutController: TextEditingController(text: t.about),
            localFilePathController: TextEditingController(),
            priceController: TextEditingController(
                text: t.finInfo?.price == null || t.finInfo?.price == 0
                    ? ""
                    : t.finInfo!.price.toString()),
            percentForSaleController: TextEditingController(
                text: t.finInfo?.percentForSale == null ||
                        t.finInfo?.percentForSale == 0
                    ? ""
                    : t.finInfo!.percentForSale.toString()),
            onRemoveTrack: (trackIndex) => removeTrackFromAlbum(trackIndex),
            onTrackOrderChanged: onTrackOrderChanged,
            shouldBeCreated: false,
            shouldBeUpdated: false,
          );
        },
      ).toList();

      trackBlocks.sort((a, b) => int.parse(a.trackOrderController.text)
          .compareTo(int.parse(b.trackOrderController.text)));
    }

    super.initState();
  }

  void onTrackOrderChanged() {
    for (var block in trackBlocks) {
      if (int.tryParse(block.trackOrderController.text) == null) {
        return;
      }

      if (!block.shouldBeCreated) {
        block.shouldBeUpdated = true;
      }
    }

    setState(() {
      trackBlocks.sort((a, b) => int.parse(a.trackOrderController.text)
          .compareTo(int.parse(b.trackOrderController.text)));
    });
  }

  void onSetAlbumImageBytesAndPath(Uint8List? imageBytes, String? imagePath) {
    setState(() {
      _albumImageBytes =
          imageBytes; // Используется для хранения данных изображения
      _albumImageLocalPath = imagePath;
    });

    if (!albumShouldBeCreated) {
      albumImageShouldBeReplaced = true;
      albumImageShouldBeMoved = false;
    }
  }

  void replaceTrackFilePaths(List<String?> filePaths) {
    setState(() {
      trackBlocks = [];

      for (var i = 0; i < filePaths.length; i++) {
        var trackIndex = i + 1;

        trackBlocks.add(
          StudioAddOrEditTrackBlock(
            trackIndex: trackIndex,
            trackOrderController:
                TextEditingController(text: trackIndex.toString()),
            nameController: TextEditingController(),
            aboutController: TextEditingController(),
            localFilePathController:
                TextEditingController(text: filePaths[i] ?? ""),
            priceController: TextEditingController(),
            percentForSaleController: TextEditingController(),
            onRemoveTrack: (trackIndex) => removeTrackFromAlbum(trackIndex),
            onTrackOrderChanged: onTrackOrderChanged,
            shouldBeCreated: true,
            shouldBeUpdated: false,
          ),
        );
      }
    });
  }

  void addNewTrackFilePaths(List<String?> filePaths) {
    setState(() {
      for (var i = 0; i < filePaths.length; i++) {
        var trackIndex = trackBlocks.length + 1;

        trackBlocks.add(
          StudioAddOrEditTrackBlock(
            trackIndex: trackIndex,
            trackOrderController:
                TextEditingController(text: trackIndex.toString()),
            nameController: TextEditingController(),
            aboutController: TextEditingController(),
            localFilePathController:
                TextEditingController(text: filePaths[i] ?? ""),
            priceController: TextEditingController(),
            percentForSaleController: TextEditingController(),
            onRemoveTrack: (trackIndex) => removeTrackFromAlbum(trackIndex),
            onTrackOrderChanged: onTrackOrderChanged,
            shouldBeCreated: true,
            shouldBeUpdated: false,
          ),
        );
      }
    });
  }

  void removeTrackFromAlbum(int trackIndex) async {
    var trackBlockToRemove =
        trackBlocks.firstWhere((bl) => bl.trackIndex == trackIndex);

    setState(() {
      trackBlocks.removeWhere((bl) => bl.trackIndex == trackIndex);
    });

    await _helper.removeTrackFromAlbum(trackBlockToRemove);
  }

  void togglePublishCheckbox(bool visible) {
    _albumVisible = visible;
    albumShouldBeUpdated = !albumShouldBeCreated;
  }

  void onAlbumNameChanged() {
    if (!albumShouldBeCreated) {
      albumShouldBeUpdated = true;

      if (_albumImageLocalPath == null) {
        albumImageShouldBeMoved = true;
      }
    }

    for (var tracksBloc in trackBlocks) {
      if (!tracksBloc.shouldBeCreated) {
        tracksBloc.muzzFileShouldBeMoved = true;
        tracksBloc.shouldBeUpdated = true;
      }
    }
  }

  void onAlbumAboutOrYearChanged() {
    if (!albumShouldBeCreated) {
      albumShouldBeUpdated = true;
    }
  }

  void createOrUpdateAlbum() async {
    await _helper.createOrUpdateAlbum(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.id == null
            ? "Add album for '${widget.album.artist!.name!}'"
            : "Edit album '${widget.album.name}'"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: mainLeftMargin),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StudioTextField(
                controller: albumNameController,
                hintText: "Name",
                keyboardType: TextInputType.name,
                maxLines: 1,
                onChanged: onAlbumNameChanged,
              ),
              const SizedBox(height: 20),

              StudioTextField(
                controller: albumYearController,
                hintText: "Year",
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: onAlbumAboutOrYearChanged,
              ),
              const SizedBox(height: 20),
              StudioTextField(
                controller: albumAboutController,
                hintText: "About Album",
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                onChanged: onAlbumAboutOrYearChanged,
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
                        _helper.pickImage();
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
                                _albumImageLocalPath != null
                                    ? // Show locally selected image
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.file(
                                          File(_albumImageLocalPath!),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : widget.album.imageUrl != null &&
                                            widget.album.imageUrl!.isNotEmpty
                                        ? // Show existing network image
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.network(
                                              widget.album.imageUrl!,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print('Add tracks button clicked!');
                          }
                          _helper.pickTracks();
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12),
                          constraints: const BoxConstraints(minWidth: 260),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: MuzzTheme.accentColor, width: 2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 20, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Add tracks",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    if (widget.album.id != null)
                      StudioAddAlbumTracksButton(
                        text: "Reaplace tracks",
                        getFilePathes: replaceTrackFilePaths,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              ...trackBlocks,
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
                            value: _albumVisible,
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
                                  createOrUpdateAlbum();
                                  if (_albumCreatedOrUpdated) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(albumShouldBeCreated
                                            ? 'Album created successfully'
                                            : 'Album updated successfully'),
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

  // Defer population to next frame to avoid layout assertions during navigation animations
}
