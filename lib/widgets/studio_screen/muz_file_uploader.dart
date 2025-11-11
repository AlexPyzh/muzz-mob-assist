import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_choose_file_field.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';
import 'package:path/path.dart';

class MuzzFileUploader extends StatefulWidget {
  MuzzFileUploader({
    required this.onGetMuzFileBytesAndPath,
    required this.fileNameController,
    this.text,
    super.key,
  });

  final TextEditingController fileNameController;
  final Function(Uint8List?, String?) onGetMuzFileBytesAndPath;
  String? text;

  @override
  State<MuzzFileUploader> createState() => _MuzzFileUploaderState();
}

class _MuzzFileUploaderState extends State<MuzzFileUploader> {
  Uint8List? fileUint8List;
  String? filePath;

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'ogg',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        fileUint8List = file.bytes;
        filePath = file.path;
        widget.fileNameController.text = filePath == null ? "" : filePath!;
        // widget.fileNameController.text =
        //     filePath == null ? "" : basename(filePath!);
      });

      widget.onGetMuzFileBytesAndPath(fileUint8List, filePath);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploadFile,
      child: StudioChooseFileField(
        controller: widget.fileNameController,
        hintText: widget.text == null ? "Tap to choose muz file" : widget.text!,
        keboardType: TextInputType.text,
        maxLines: 1,
      ),
    );
  }
}
