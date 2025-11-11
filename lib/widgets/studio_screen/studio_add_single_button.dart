import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_button_base.dart';

class StudioAddSingleButton extends StatelessWidget {
  const StudioAddSingleButton({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return StudioButtonBase(
      onPressed: () {
        Navigator.of(context).pushNamed(
          studioAddOrEditSingleScreenPath,
          arguments: Track(
            artist: artist,
          ),
        );
      },
      caption: "+ Add single",
    );
  }
}
