import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/utils/string_utils.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/image_uploader.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_category_checkbox.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_publish_checkbox.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';

class StudioCreateArtistScreen extends StatefulWidget {
  const StudioCreateArtistScreen({super.key});

  @override
  State<StudioCreateArtistScreen> createState() =>
      _StudioCreateArtistScreenState();
}

class _StudioCreateArtistScreenState extends State<StudioCreateArtistScreen> {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageLocalPath;
  final _muzzClient = MuzzClient();
  late dynamic authProvider;
  bool visible = false;
  Future<List<CategoryMuz>?>? existingCategories;
  Map<CategoryMuz, bool> categoryMap = {};

  @override
  void initState() {
    getExistingCategories();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  void getExistingCategories() async {
    existingCategories = _muzzClient.getCategories();
    var gotCats = await existingCategories;

    if (gotCats != null) {
      for (var cat in gotCats) {
        categoryMap[cat] = false;
      }
    }
  }

  void toggleCategory(String categoryName, bool isChecked) {
    categoryMap[categoryMap.entries
        .firstWhere((c) => c.key.name == categoryName)
        .key] = isChecked;
  }

  void togglePublishCheckbox(bool publish) {
    visible = publish;
  }

  void setImagePath(Uint8List? imageBytes, String? imagePath) {
    _imageBytes = imageBytes;
    _imageLocalPath = imagePath;
  }

  List<Widget> makeCheckBoxes(List<CategoryMuz> categories) {
    List<StudioCategoryCheckbox> chekBoxes = [];

    for (var cat in categoryMap.entries) {
      chekBoxes.add(StudioCategoryCheckbox(
        categoryName: cat.key.name!,
        onToggleCategory: toggleCategory,
      ));
    }
    return chekBoxes;
  }

  void createArtist() {
    List<CategoryMuz> newArtistCats = [];

    for (var cat in categoryMap.entries) {
      if (cat.value) {
        newArtistCats.add(cat.key);
      }
    }

    var imageExtension = _imageLocalPath!.split(".").last;

    var imageFileName = StringUtils().createArtistImageFileName(
      nameController.text,
      imageExtension,
    );

    var imageRemotePath = StringUtils().createArtistImageFilePath(
      nameController.text,
      imageFileName,
    );

    var newArtist = Artist(
      userId: authProvider.loggedInUser.id,
      name: nameController.text,
      about: aboutController.text,
      imageUrl: imageRemotePath,
      categories: newArtistCats,
      visible: visible,
    );

    _muzzClient.uploadImageFromPath(
      _imageLocalPath!,
      imageRemotePath,
      imageFileName,
    );

    _muzzClient.createArtist(newArtist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create artist"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mainLeftMargin),
          child: Column(
            children: [
              StudioTextField(
                controller: nameController,
                hintText: "Artist name",
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: () {},
              ),
              const SizedBox(height: 20),
              StudioTextField(
                controller: aboutController,
                hintText: "About",
                keyboardType: TextInputType.text,
                maxLines: 10,
                onChanged: () {},
              ),
              const SizedBox(height: 20),
              ImageUploader(
                onGetImageBytesAndPath: setImagePath,
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<CategoryMuz>?>(
                future: existingCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 70,
                      width: 200,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Wrap(
                      runSpacing: 15,
                      spacing: 10,
                      children: makeCheckBoxes(snapshot.data!),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              StudioPublishCheckbox(
                onTogglePublish: togglePublishCheckbox,
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: mainLeftMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StudioButtonBase(
                      onPressed: () {
                        createArtist();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Artist was created!'),
                          ),
                        );
                      },
                      caption: "Create",
                    ),
                    StudioButtonBase(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      caption: "Cancel",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
