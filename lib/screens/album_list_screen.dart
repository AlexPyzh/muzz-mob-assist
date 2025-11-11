import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/widgets/artist_screen/albums_grid.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({
    super.key,
    required this.appBarTitle,
    required this.albums,
  });

  final String appBarTitle;
  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: AlbumsGrid(albums: albums),
        ),
      ),
    );
  }
}
