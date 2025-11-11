import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/fin_info.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/utils/string_utils.dart';

class AddEditSingleHelper {
  final Track track;
  final TextEditingController nameController;
  final TextEditingController yearController;
  final TextEditingController aboutController;
  final TextEditingController localFilePathController;
  final TextEditingController priceController;
  final TextEditingController percentForSaleController;
  final dynamic studioProvider;
  final bool Function() getShouldBeCreated;
  final bool Function() getShouldBeUpdated;
  final bool Function() getMuzFileShouldBeReplaced;
  final bool Function() getImageFileShouldBeReplaced;
  final String? Function() getImageLocalPath;
  final String? Function() getMuzFileLocalPath;
  final bool Function() getVisible;
  final void Function(bool) setSingleCreatedOrUpdated;
  final void Function(Uint8List?, String?) onSetImageBytesAndPath;
  final void Function(Uint8List?, String?) onSetMuzFileBytesAndPath;

  AddEditSingleHelper({
    required this.track,
    required this.nameController,
    required this.yearController,
    required this.aboutController,
    required this.localFilePathController,
    required this.priceController,
    required this.percentForSaleController,
    required this.studioProvider,
    required this.getShouldBeCreated,
    required this.getShouldBeUpdated,
    required this.getMuzFileShouldBeReplaced,
    required this.getImageFileShouldBeReplaced,
    required this.getImageLocalPath,
    required this.getMuzFileLocalPath,
    required this.getVisible,
    required this.setSingleCreatedOrUpdated,
    required this.onSetImageBytesAndPath,
    required this.onSetMuzFileBytesAndPath,
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
    if (nameController.text.trim() == "") {
      showValidationDialog(context, "Empty fields", "Please name your single");
      setSingleCreatedOrUpdated(false);
      return false;
    }

    if (getShouldBeCreated() && localFilePathController.text.trim() == "") {
      showValidationDialog(
          context, "No muz file", "Please choose file for your single");
      setSingleCreatedOrUpdated(false);
      return false;
    }

    if (getShouldBeCreated() && getImageLocalPath() == null) {
      showValidationDialog(
          context, "No image", "Please choose image for your single");
      setSingleCreatedOrUpdated(false);
      return false;
    }

    return true;
  }

  Future<void> pickImage() async {
    try {
      print('pickImage method called!');
      print('About to show image file picker...');

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      print('Image file picker returned: ${result?.files.length ?? 0} files');

      if (result != null) {
        PlatformFile file = result.files.first;
        print('Image picked: ${file.path}');
        onSetImageBytesAndPath(file.bytes, file.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> pickMuzFile() async {
    try {
      print('pickMuzFile method called!');
      print('About to show muz file picker...');

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'ogg', 'wav', 'flac'],
      );

      print('Muz file picker returned: ${result?.files.length ?? 0} files');

      if (result != null) {
        PlatformFile file = result.files.first;
        print('Muz file picked: ${file.path}');
        localFilePathController.text = file.path ?? '';
        onSetMuzFileBytesAndPath(file.bytes, file.path);
      }
    } catch (e) {
      print('Error picking muz file: $e');
    }
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              getShouldBeCreated()
                  ? "Creating single..."
                  : "Updating single...",
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

  Future<String> uploadImage() async {
    final imageLocalPath = getImageLocalPath()!;
    var imageExtension = imageLocalPath.split(".").last;

    var imageFileName = StringUtils().createSingleOrAlbumImageFileName(
      track.artist!.name!,
      nameController.text,
      imageExtension,
    );

    var imageRemotePath = StringUtils().createSingleImageFilePath(
      track.artist!.name!,
      imageFileName,
    );

    await MuzzClient().uploadImageFromPath(
      imageLocalPath,
      imageRemotePath,
      imageFileName,
    );

    return imageRemotePath;
  }

  Future<String> replaceImage() async {
    if (track.imageUrl != null) {
      await MuzzClient().deleteImage(
        StringUtils().getFilePathFromUrl(
          track.imageUrl!,
          StringUtils().trimString(track.artist!.name!),
        ),
      );
    }

    var imageRemotePath = await uploadImage();
    return imageRemotePath;
  }

  Future<String> moveImageFile() async {
    var imageExtension = track.imageUrl!.split(".").last;

    var imageFileName = StringUtils().createSingleOrAlbumImageFileName(
      track.artist!.name!,
      nameController.text,
      imageExtension,
    );

    var imageFileRemotePath = StringUtils().createSingleImageFilePath(
      track.artist!.name!,
      imageFileName,
    );

    await MuzzClient().moveImageFile(
      StringUtils().getFilePathFromUrl(
        track.imageUrl!,
        track.artist!.name!,
      ),
      imageFileRemotePath,
    );

    return imageFileRemotePath;
  }

  Future<String> uploadMuzFile() async {
    var muzExtension = localFilePathController.text.split(".").last;

    var muzFileName = StringUtils().createSingleMuzFileName(
      track.artist!.name!,
      nameController.text,
      muzExtension,
    );

    var muzFileRemotePath = StringUtils().createSingleMuzFilePath(
      track.artist!.name!,
      muzFileName,
    );

    await MuzzClient().uploadMuzFileFromPath(
      localFilePathController.text,
      muzFileRemotePath,
      muzFileName,
    );

    return muzFileRemotePath;
  }

  Future<String> moveMuzFile() async {
    var muzFileName = StringUtils().createSingleMuzFileName(
      track.artist!.name!,
      nameController.text,
      track.streamingUrl!.split(".").last,
    );

    var muzFileRemotePath = StringUtils().createSingleMuzFilePath(
      track.artist!.name!,
      muzFileName,
    );

    MuzzClient().moveMuzFile(
      StringUtils().getFilePathFromUrl(
        track.streamingUrl!,
        track.artist!.name!,
      ),
      muzFileRemotePath,
    );

    return muzFileRemotePath;
  }

  Future<String> replaceMuzFile() async {
    if (track.streamingUrl != null) {
      MuzzClient().deleteMuzFile(
        StringUtils().getFilePathFromUrl(
          track.streamingUrl!,
          track.artist!.name!,
        ),
      );
    }

    var muzFileRemotePath = await uploadMuzFile();
    return muzFileRemotePath;
  }

  Future<void> createTrack(
    String imageRemotePath,
    String muzFileRemotePath,
  ) async {
    var newTrack = Track(
      name: nameController.text,
      about: aboutController.text,
      artistId: track.artist!.id,
      imageUrl: imageRemotePath,
      streamingUrl: muzFileRemotePath,
      isSingle: true,
      year: int.tryParse(yearController.text),
      visible: getVisible(),
      deleted: false,
      created: DateTime.now().toUtc(),
      finInfo: FinInfo(
        price: double.tryParse(priceController.text),
        percentForSale: double.tryParse(percentForSaleController.text),
      ),
    );

    await MuzzClient().createTrack(newTrack);
  }

  Future<void> updateTrack(
    String imageRemotePath,
    String muzFileRemotePath,
  ) async {
    var updatedTrack = Track(
      id: track.id,
      name: nameController.text,
      about: aboutController.text,
      artistId: track.artist!.id,
      imageUrl: imageRemotePath != ""
          ? imageRemotePath
          : StringUtils().getFilePathFromUrl(
              track.imageUrl!,
              track.artist!.name!,
            ),
      streamingUrl: muzFileRemotePath != ""
          ? muzFileRemotePath
          : StringUtils().getFilePathFromUrl(
              track.streamingUrl!,
              track.artist!.name!,
            ),
      isSingle: true,
      year: int.tryParse(yearController.text),
      visible: getVisible(),
      deleted: false,
      created: track.created ?? DateTime.now().toUtc(),
      finInfo: FinInfo(
        price: double.tryParse(priceController.text),
        percentForSale: double.tryParse(percentForSaleController.text),
      ),
    );

    await MuzzClient().updateTrack(updatedTrack);
  }

  Future<void> updateStudioProvider() async {
    var updatedArtist = await MuzzClient().getArtistById(
      track.artist!.id!,
      showNotPublished: true,
    );
    studioProvider.artist = updatedArtist;
  }
}
