import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';

class StudioAddAlbumTracksButton extends StatelessWidget {
  StudioAddAlbumTracksButton({
    super.key,
    required this.text,
    required this.getFilePathes,
  });

  final String text;
  final Function(List<String?>) getFilePathes;

  final filePathController = TextEditingController();
  Uint8List? fileUint8List;
  List<String?> filePaths = [];

  uploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: [
        'mp3',
        'ogg',
      ],
    );

    if (result != null) {
      filePaths = result.files.map((f) => f.path).toList();
      getFilePathes(filePaths);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudioButtonBase(
      onPressed: uploadFiles,
      caption: text,
    );
  }
}
