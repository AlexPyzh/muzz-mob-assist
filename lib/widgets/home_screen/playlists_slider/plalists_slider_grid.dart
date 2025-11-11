import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/config/app_scroll_behavior.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/playlists_slider/playlists_slider_item.dart';

class PlaylistsSliderGrid extends StatelessWidget {
  const PlaylistsSliderGrid({
    super.key,
    required this.playlists,
    this.rowCount = 2,
  });

  final List<Playlist> playlists;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    double heght = (150 * rowCount).toDouble();
    return SizedBox(
      width: double.infinity,
      height: heght,
      child: ScrollConfiguration(
        behavior: AppScrollBehavior(),
        child: GridView(
          padding: const EdgeInsets.symmetric(horizontal: mainLeftMargin),
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              crossAxisCount: rowCount,
              childAspectRatio: 1.0),
          children:
              playlists.map((p) => PLaylistsSliderItem(playlist: p)).toList(),
        ),
      ),
    );
  }
}
