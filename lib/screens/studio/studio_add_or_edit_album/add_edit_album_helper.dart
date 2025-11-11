import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/fin_info.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/models/http_models/create_album_response.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/utils/string_utils.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_or_edit_track_block.dart';

class AddEditAlbumHelper {
  final Album album;
  final TextEditingController albumNameController;
  final TextEditingController albumYearController;
  final TextEditingController albumAboutController;
  final dynamic studioProvider;
  final List<StudioAddOrEditTrackBlock> trackBlocks;
  final bool Function() getAlbumShouldBeCreated;
  final bool Function() getAlbumShouldBeUpdated;
  final bool Function() getAlbumImageShouldBeMoved;
  final String? Function() getAlbumImageLocalPath;
  final bool Function() getAlbumVisible;
  final void Function(bool) setAlbumCreatedOrUpdated;
  final void Function(Uint8List?, String?) onSetAlbumImageBytesAndPath;
  final void Function(List<String?>) addNewTrackFilePaths;

  AddEditAlbumHelper({
    required this.album,
    required this.albumNameController,
    required this.albumYearController,
    required this.albumAboutController,
    required this.studioProvider,
    required this.trackBlocks,
    required this.getAlbumShouldBeCreated,
    required this.getAlbumShouldBeUpdated,
    required this.getAlbumImageShouldBeMoved,
    required this.getAlbumImageLocalPath,
    required this.getAlbumVisible,
    required this.setAlbumCreatedOrUpdated,
    required this.onSetAlbumImageBytesAndPath,
    required this.addNewTrackFilePaths,
  });

  Future<void> showValidationDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          content: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool fieldsValidated(BuildContext context) {
    for (var trackBlock in trackBlocks) {
      if (trackBlock.nameController.text.trim() == "") {
        showValidationDialog(context, "Empty fields", "Please name all tracks");
        setAlbumCreatedOrUpdated(false);
        return false;
      }
    }

    for (var trackBlock in trackBlocks) {
      if (trackBlock.shouldBeCreated &&
          trackBlock.localFilePathController.text.trim() == "") {
        showValidationDialog(
            context, "No muz file", "Please choose files for all new tracks");
        setAlbumCreatedOrUpdated(false);
        return false;
      }
    }

    if (getAlbumShouldBeCreated() && getAlbumImageLocalPath() == null) {
      showValidationDialog(
          context, "No image", "Please choose image for your album");
      setAlbumCreatedOrUpdated(false);
      return false;
    }

    return true;
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              "Creating album...",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> pickImage() async {
    if (kDebugMode) {
      print('pickImage method called!');
    }

    try {
      if (kDebugMode) {
        print('About to show file picker...');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        dialogTitle: 'Choose Album Cover Image',
        allowMultiple: false,
      );

      if (kDebugMode) {
        print('File picker returned: ${result?.files.length ?? 0} files');
      }

      if (result != null) {
        if (kDebugMode) {
          print('File picked: ${result.files.first.path}');
        }
        PlatformFile file = result.files.first;
        onSetAlbumImageBytesAndPath(file.bytes, file.path);
      } else {
        if (kDebugMode) {
          print('File picker cancelled');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  Future<void> pickTracks() async {
    if (kDebugMode) {
      print('pickTracks method called!');
    }

    try {
      if (kDebugMode) {
        print('About to show tracks file picker...');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'ogg', 'wav', 'flac'],
        dialogTitle: 'Choose Audio Tracks',
        allowMultiple: true,
      );

      if (kDebugMode) {
        print(
            'Tracks file picker returned: ${result?.files.length ?? 0} files');
      }

      if (result != null) {
        List<String?> filePaths = result.files.map((f) => f.path).toList();
        if (kDebugMode) {
          print('Tracks picked: ${filePaths.length}');
        }
        addNewTrackFilePaths(filePaths);
      } else {
        if (kDebugMode) {
          print('Tracks file picker cancelled');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking tracks: $e');
      }
    }
  }

  Future<String> uploadAlbumImage() async {
    final albumImageLocalPath = getAlbumImageLocalPath()!;
    var imageExtension = albumImageLocalPath.split(".").last;

    var imageFileName = StringUtils().createSingleOrAlbumImageFileName(
      album.artist!.name!,
      albumNameController.text,
      imageExtension,
    );

    var imageFileRemotePath = StringUtils().createAlbumImageFilePath(
      album.artist!.name!,
      imageFileName,
    );

    await MuzzClient().uploadImageFromPath(
      albumImageLocalPath,
      imageFileRemotePath,
      imageFileName,
    );

    return imageFileRemotePath;
  }

  Future<String> replaceAlbumImage() async {
    if (album.imageUrl != null && album.imageUrl!.isNotEmpty) {
      await MuzzClient().deleteImage(
        StringUtils().getFilePathFromUrl(
          album.imageUrl!,
          album.artist!.name!,
        ),
      );
    }

    var imageRemotePath = await uploadAlbumImage();
    return imageRemotePath;
  }

  Future<String?> moveAlbumImage() async {
    var imageExtension = album.imageUrl!.split(".").last;

    var imageFileName = StringUtils().createSingleOrAlbumImageFileName(
      album.artist!.name!,
      albumNameController.text,
      imageExtension,
    );

    var imageFileRemotePath = StringUtils().createAlbumImageFilePath(
      album.artist!.name!,
      imageFileName,
    );

    await MuzzClient().moveImageFile(
      StringUtils().getFilePathFromUrl(
        album.imageUrl!,
        album.artist!.name!,
      ),
      imageFileRemotePath,
    );

    return imageFileRemotePath;
  }

  Future<CreateOrUpdateAlbumResponse> updateAlbum(
      String? imageFileRemotePath) async {
    var updatedAlbum = Album(
      id: album.id,
      name: albumNameController.text,
      artistId: album.artist!.id,
      imageUrl: imageFileRemotePath ??
          StringUtils().getFilePathFromUrl(
            album.imageUrl!,
            album.artist!.name!,
          ),
      year: albumYearController.text,
      description: albumAboutController.text,
      visible: getAlbumVisible(),
      created: album.created,
    );

    var updateAlbumResponse = await MuzzClient().updateAlbum(updatedAlbum);

    return updateAlbumResponse;
  }

  Future<CreateOrUpdateAlbumResponse> createAlbum(
      String imageFileRemotePath) async {
    var newAlbum = Album(
      name: albumNameController.text,
      artistId: album.artist!.id,
      imageUrl: imageFileRemotePath,
      year: albumYearController.text,
      description: albumAboutController.text,
      visible: getAlbumVisible(),
      created: DateTime.now().toUtc(),
    );

    var createAlbumResponse = await MuzzClient().createAlbum(newAlbum);

    return createAlbumResponse;
  }

  Future<String> moveMuzFile(StudioAddOrEditTrackBlock trackBlock) async {
    var muzFileName = StringUtils().createAlbumMuzFileName(
      album.artist!.name!,
      albumNameController.text,
      trackBlock.nameController.text,
      trackBlock.track!.streamingUrl!.split(".").last,
    );

    var muzFileRemotePath = StringUtils().createAlbumMuzFilePath(
      trackBlock.track!.artist!.name!,
      albumNameController.text,
      muzFileName,
    );

    MuzzClient().moveMuzFile(
      StringUtils().getFilePathFromUrl(
        trackBlock.track!.streamingUrl!,
        trackBlock.track!.artist!.name!,
      ),
      muzFileRemotePath,
    );

    return muzFileRemotePath;
  }

  Future<String> replaceMuzFile(StudioAddOrEditTrackBlock trackBlock) async {
    if (trackBlock.track?.streamingUrl != null) {
      MuzzClient().deleteMuzFile(
        StringUtils().getFilePathFromUrl(
            trackBlock.track!.streamingUrl!, trackBlock.track!.artist!.name!),
      );
    }

    var muzFileRemotePath = await uploadMuzFile(trackBlock);
    return muzFileRemotePath;
  }

  Future<String> uploadMuzFile(StudioAddOrEditTrackBlock trackBlock) async {
    var muzExtension = trackBlock.localFilePathController.text.split(".").last;

    var muzFileName = StringUtils().createAlbumMuzFileName(
      album.artist!.name!,
      albumNameController.text,
      trackBlock.nameController.text,
      muzExtension,
    );

    var muzFileRemotePath = StringUtils().createAlbumMuzFilePath(
      album.artist!.name!,
      albumNameController.text,
      muzFileName,
    );

    await MuzzClient().uploadMuzFileFromPath(
      trackBlock.localFilePathController.text,
      muzFileRemotePath,
      muzFileName,
    );

    return muzFileRemotePath;
  }

  Future createTrack(
    StudioAddOrEditTrackBlock trackBlock,
    int albumId,
    String muzFileRemotePath,
  ) async {
    var finInfo = trackBlock.priceController.text.isEmpty
        ? null
        : FinInfo(
            price: double.tryParse(trackBlock.priceController.text),
            percentForSale:
                double.tryParse(trackBlock.percentForSaleController.text),
          );

    var newAlbumTrack = Track(
      name: trackBlock.nameController.text,
      about: trackBlock.aboutController.text,
      year: int.tryParse(albumYearController.text),
      artistId: album.artist!.id,
      albumId: albumId,
      albumOrder: int.parse(trackBlock.trackOrderController.text),
      streamingUrl: muzFileRemotePath,
      isSingle: false,
      visible: getAlbumVisible(),
      deleted: false,
      created: DateTime.now().toUtc(),
      finInfo: finInfo,
    );

    await MuzzClient().createTrack(newAlbumTrack);
  }

  Future updateTrack(
    StudioAddOrEditTrackBlock trackBlock,
    int albumId,
    String muzFileRemotePath,
  ) async {
    var updatedAlbumTrack = Track(
      id: trackBlock.track!.id,
      name: trackBlock.nameController.text,
      about: trackBlock.aboutController.text,
      year: int.tryParse(albumYearController.text),
      artistId: album.artist!.id,
      albumId: albumId,
      albumOrder: int.parse(trackBlock.trackOrderController.text),
      streamingUrl: muzFileRemotePath != ""
          ? muzFileRemotePath
          : StringUtils().getFilePathFromUrl(
              trackBlock.track!.streamingUrl!, trackBlock.track!.artist!.name!),
      isSingle: false,
      visible: getAlbumVisible(),
      deleted: false,
      created: DateTime.now().toUtc(),
      finInfo: FinInfo(
        price: double.tryParse(trackBlock.priceController.text),
        percentForSale:
            double.tryParse(trackBlock.percentForSaleController.text),
      ),
    );

    await MuzzClient().updateTrack(updatedAlbumTrack);
  }

  Future createOrUpdateTracksWithinAlbum(int albumId) async {
    int order = 1;
    for (var block in trackBlocks) {
      block.trackOrderController.text = order.toString();
      order++;
    }

    for (var trackBlock in trackBlocks) {
      String? muzFileRemotePath;

      if (trackBlock.shouldBeCreated) {
        muzFileRemotePath = await uploadMuzFile(trackBlock);
        await createTrack(trackBlock, albumId, muzFileRemotePath);
      } else if (trackBlock.muzzFileShouldBeMoved) {
        muzFileRemotePath = await moveMuzFile(trackBlock);
        await updateTrack(trackBlock, albumId, muzFileRemotePath);
      } else if (trackBlock.muzzFileShouldBeReplaced) {
        muzFileRemotePath = await replaceMuzFile(trackBlock);
      } else if (trackBlock.shouldBeUpdated) {
        await updateTrack(trackBlock, albumId, "");
      }
    }
  }

  Future updateStudioProvider() async {
    var updatedArtist = await MuzzClient().getArtistById(
      album.artist!.id!,
      showNotPublished: true,
    );
    studioProvider.artist = updatedArtist;
  }

  void killDialogAndMoveBack(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
  }

  Future<void> removeTrackFromAlbum(
      StudioAddOrEditTrackBlock trackBlockToRemove) async {
    if (trackBlockToRemove.track != null) {
      MuzzClient().deleteTrack(trackBlockToRemove.track!.id!);

      if (trackBlockToRemove.track?.streamingUrl != null) {
        MuzzClient().deleteMuzFile(
          StringUtils().getFilePathFromUrl(
              trackBlockToRemove.track!.streamingUrl!,
              trackBlockToRemove.track!.artist!.name!),
        );
      }
    }
  }

  Future<void> createOrUpdateAlbum(BuildContext context) async {
    if (!fieldsValidated(context)) {
      return;
    }

    showLoaderDialog(context);

    String? imageFileRemotePath;
    int? albumId;

    final albumImageLocalPath = getAlbumImageLocalPath();
    if (albumImageLocalPath != null && albumImageLocalPath != "") {
      if (getAlbumShouldBeCreated()) {
        imageFileRemotePath = await uploadAlbumImage();
      } else {
        imageFileRemotePath = await replaceAlbumImage();
      }
    } else if (getAlbumImageShouldBeMoved()) {
      imageFileRemotePath = await moveAlbumImage();
    }

    if (getAlbumShouldBeCreated()) {
      var createAlbumResponse = await createAlbum(imageFileRemotePath!);
      albumId = createAlbumResponse.data?.id;
    } else if (getAlbumShouldBeUpdated()) {
      var updateAlbumResponse = await updateAlbum(imageFileRemotePath);
      albumId = updateAlbumResponse.data!.id;
    }

    await createOrUpdateTracksWithinAlbum(albumId ?? album.id!);
    await updateStudioProvider();
    killDialogAndMoveBack(context);
    setAlbumCreatedOrUpdated(true);
  }
}
