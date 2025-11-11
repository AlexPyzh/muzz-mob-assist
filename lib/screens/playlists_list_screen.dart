import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/screens/playlist_screen.dart';
import 'package:muzzbirzha_mobile/widgets/playlists_list/playlists_list_grid.dart';

class PlaylistsListScreen extends StatelessWidget {
  const PlaylistsListScreen(
      {super.key, required this.appBarTitle, required this.playlists});

  final String appBarTitle;
  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: PlayListsListGrid(
        playlists: playlists,
      ),
    );
  }
}
