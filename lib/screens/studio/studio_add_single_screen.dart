// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:muzzbirzha_mobile/consts/consts.dart';
// import 'package:muzzbirzha_mobile/models/global_using_models.dart';
// import 'package:muzzbirzha_mobile/network/muzz_client.dart';
// import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
// import 'package:muzzbirzha_mobile/utils/string_utils.dart';
// import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
// import 'package:muzzbirzha_mobile/widgets/studio_screen/image_uploader.dart';
// import 'package:muzzbirzha_mobile/widgets/studio_screen/muz_file_uploader.dart';
// import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';
// import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_publish_checkbox.dart';
// import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';

// class StudioAddSingleScreen extends StatefulWidget {
//   const StudioAddSingleScreen({
//     super.key,
//     required this.artist,
//   });

//   final Artist artist;

//   @override
//   State<StudioAddSingleScreen> createState() => _StudioAddSingleScreenState();
// }

// class _StudioAddSingleScreenState extends State<StudioAddSingleScreen> {
//   late final dynamic studioProvider;
//   final _muzzClient = MuzzClient();
//   final nameController = TextEditingController();
//   final yearController = TextEditingController();
//   final aboutController = TextEditingController();
//   final muzzFileNameController = TextEditingController();

//   Uint8List? _imageBytes;
//   String? _imageLocalPath;
//   Uint8List? _muzFileBytes;
//   String? _muzFileLocalPath;
//   bool? visible = false;

//   @override
//   void initState() {
//     studioProvider = Provider.of<StudioProvider>(context, listen: false);
//     super.initState();
//   }

//   void setImageBytesAndPath(Uint8List? imageBytes, String? imagePath) {
//     _imageBytes = imageBytes;
//     _imageLocalPath = imagePath;
//   }

//   void setMuzFileBytesAndPath(Uint8List? muzzBytes, String? muzzPath) {
//     _muzFileBytes = muzzBytes;
//     _muzFileLocalPath = muzzPath;
//   }

//   void togglePublishCheckbox(bool publish) {
//     visible = publish;
//   }

//   void createSingle() async {
//     // upload image
//     if (_imageLocalPath == null) {
//       return;
//     }

//     var imageExtension = _imageLocalPath!.split(".").last;

//     var imageFileName = StringUtils().createSingleOrAlbumImageFileName(
//       widget.artist.name!,
//       nameController.text,
//       imageExtension,
//     );

//     var imageRemotePath = StringUtils().createSingleImageFilePath(
//       widget.artist.name!,
//       imageFileName,
//     );

//     _muzzClient.uploadImageFromPath(
//       _imageLocalPath!,
//       imageRemotePath,
//       imageFileName,
//     );

//     // upload muz
//     var muzExtension = _muzFileLocalPath!.split(".").last;

//     var muzFileName = StringUtils().createSingleMuzFileName(
//       widget.artist.name!,
//       nameController.text,
//       muzExtension,
//     );

//     var muzRemotePath = StringUtils().createSingleMuzFilePath(
//       widget.artist.name!,
//       muzFileName,
//     );

//     await _muzzClient.uploadMuzFileFromPath(
//       _muzFileLocalPath!,
//       muzRemotePath,
//       muzFileName,
//     );

//     // ceate track
//     var newSingle = Track(
//       name: nameController.text,
//       about: aboutController.text,
//       imageUrl: imageRemotePath,
//       artistId: widget.artist.id,
//       categories: [],
//       year: int.tryParse(yearController.text),
//       streamingUrl: muzRemotePath,
//       isSingle: true,
//       visible: visible,
//       deleted: false,
//       created: DateTime.now().toUtc(),
//     );

//     await _muzzClient.createTrack(newSingle);
//     var updatedArtist = await _muzzClient.getArtistById(widget.artist.id!);
//     studioProvider.artist = updatedArtist;

//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add single for ${widget.artist.name}"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: mainLeftMargin),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               StudioTextField(
//                 controller: nameController,
//                 hintText: "Name",
//                 keyboardType: TextInputType.name,
//                 maxLines: 1,
//                 onChanged: () {},
//               ),
//               const SizedBox(height: 20),
//               StudioTextField(
//                 controller: yearController,
//                 hintText: "Year",
//                 keyboardType: TextInputType.number,
//                 maxLines: 1,
//                 onChanged: () {},
//               ),
//               const SizedBox(height: 20),
//               StudioTextField(
//                 controller: aboutController,
//                 hintText: "About",
//                 keyboardType: TextInputType.multiline,
//                 maxLines: 1,
//                 onChanged: () {},
//               ),
//               const SizedBox(height: 20),
//               ImageUploader(
//                 onGetImageBytesAndPath: setImageBytesAndPath,
//               ),
//               const SizedBox(height: 20),
//               MuzzFileUploader(
//                   onGetMuzFileBytesAndPath: setMuzFileBytesAndPath,
//                   fileNameController: muzzFileNameController),
//               const SizedBox(height: 20),
//               StudioPublishCheckbox(
//                 onTogglePublish: togglePublishCheckbox,
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   StudioButtonBase(
//                     onPressed: () {
//                       createSingle();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Artist was created!'),
//                         ),
//                       );
//                     },
//                     caption: "Create",
//                   ),
//                   StudioButtonBase(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     caption: "Cancel",
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
