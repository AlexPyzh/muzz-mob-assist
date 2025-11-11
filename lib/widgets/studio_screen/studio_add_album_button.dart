import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';

class StudioAddAlbumButton extends StatelessWidget {
  const StudioAddAlbumButton({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return StudioButtonBase(
      onPressed: () {
        Navigator.of(context).pushNamed(
          studioAddOrEditAlbumScreenPath,
          arguments: Album(
            artist: artist,
          ),
        );
      },
      caption: "+ Add album",
    );
  }
}
