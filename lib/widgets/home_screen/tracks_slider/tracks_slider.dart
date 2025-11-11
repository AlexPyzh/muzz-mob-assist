import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/tracks_slider/tracks_slider_grid.dart';
import 'package:muzzbirzha_mobile/widgets/block_title.dart';

class TracksSlider extends StatelessWidget {
  const TracksSlider({
    super.key,
    required this.title,
    required this.tracks,
    this.rowCount = 2,
    required this.navigationPath,
  });

  final String title;
  final List<Track> tracks;
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
          tracks: tracks,
        ),
        const SizedBox(height: 10),
        TracksSliderGrid(
          tracks: tracks,
          rowCount: rowCount,
        ),
      ],
    );
  }
}
