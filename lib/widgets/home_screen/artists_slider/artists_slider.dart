import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/artists_slider/artists_slider_grid.dart';
import 'package:muzzbirzha_mobile/widgets/block_title.dart';

class ArtistsSlider extends StatelessWidget {
  const ArtistsSlider({
    super.key,
    required this.title,
    required this.artists,
    required this.navigationPath,
    this.rowCount = 1,
  });

  final String title;
  final List<Artist> artists;
  final int rowCount;
  final String navigationPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlockTitle(
          title: title,
          navigationPath: navigationPath,
        ),
        const SizedBox(height: 10),
        ArtistsSliderGrid(
          artists: artists,
          rowCount: rowCount,
        ),
      ],
    );
  }
}
