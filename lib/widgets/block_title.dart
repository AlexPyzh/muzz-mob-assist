import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class BlockTitle extends StatelessWidget {
  const BlockTitle({
    super.key,
    required this.title,
    required this.navigationPath,
    this.tracks,
    this.playlists,
    this.albums,
    this.artist,
  });

  final String title;
  final String navigationPath;
  final List<Track>? tracks;
  final List<Playlist>? playlists;
  final List<Album>? albums;
  final Artist? artist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (tracks == null &&
            playlists == null &&
            albums == null &&
            artist == null) {
          Navigator.pushNamed(context, navigationPath);
        }
        if (tracks != null) {
          Navigator.pushNamed(context, navigationPath, arguments: tracks);
        }
        if (playlists != null) {
          Navigator.pushNamed(context, navigationPath, arguments: playlists);
        }
        if (albums != null) {
          Navigator.pushNamed(context, navigationPath, arguments: albums);
        }
        if (artist != null) {
          Navigator.pushNamed(context, navigationPath, arguments: artist);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: mainLeftMargin),
        child: Text(
          title,
          style: MuzzTheme.sectionTitleStyle,
        ),
      ),
    );
  }
}
