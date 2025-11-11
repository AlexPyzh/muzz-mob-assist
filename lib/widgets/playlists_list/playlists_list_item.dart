import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/screens/playlist_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class PlaylistsListItem extends StatelessWidget {
  const PlaylistsListItem({
    super.key,
    required this.playlist,
    required this.itemWidth,
  });

  final Playlist playlist;
  final int itemWidth;

  void showPlaylistScreen(BuildContext context, Playlist playlist) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PLaylistScreen(
          playlist: playlist,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPlaylistScreen(context, playlist);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(playlist.imageUrl!),
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  child: Column(
                    children: [
                      Text(
                        playlist.name!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        playlist.description!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
