import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/widgets/block_title.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/playlists_slider/plalists_slider_grid.dart';

class PlaylistsSlider extends StatelessWidget {
  const PlaylistsSlider({
    super.key,
    required this.title,
    required this.playlists,
    required this.navigationPath,
    this.rowCount = 1,
  });

  final String title;
  final List<Playlist> playlists;
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
          playlists: playlists,
        ),
        const SizedBox(height: 10),
        PlaylistsSliderGrid(
          playlists: playlists,
          rowCount: rowCount,
        ),
      ],
    );
  }
}
