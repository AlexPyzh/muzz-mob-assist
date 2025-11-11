import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageUploader extends StatefulWidget {
  ImageUploader({
    required this.onGetImageBytesAndPath,
    this.text,
    this.imageUrl,
    super.key,
  });

  final Function(Uint8List?, String?) onGetImageBytesAndPath;
  String? text;
  String? imageUrl;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  Uint8List? imageUint8List;
  String? imagePath;

  uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'svg',
        'jpeg',
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        imageUint8List = file.bytes;
        imagePath = file.path;
      });

      widget.onGetImageBytesAndPath(imageUint8List, imagePath);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.white70, width: 2.0),
      ),
      width: 300,
      height: 300,
      child: GestureDetector(
        onTap: () => uploadImage(),
        child: imagePath != null
            ? Image.file(File(imagePath!), fit: BoxFit.cover)
            : imageUint8List != null
                ? Image.memory(imageUint8List!, fit: BoxFit.cover)
                : widget.imageUrl != null
                    ? Image.network(widget.imageUrl!)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.text == null
                                ? 'Tap to choose image'
                                : widget.text!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.upload_file,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
      ),
    );
  }
}
