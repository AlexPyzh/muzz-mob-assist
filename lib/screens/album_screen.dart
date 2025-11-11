import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    super.key,
    required this.album,
  });

  final Album album;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<TrackListProvider>(
      builder: (context, value, child) => CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            automaticallyImplyLeading: true,
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                  start: 16, bottom: 16, end: 16),
              background: SafeNetworkImage(
                imageUrl: widget.album.imageUrl!,
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.album.name!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/artist",
                            arguments: widget.album.artistId!),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.album.artist!.imageUrl!),
                          radius: 25,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.album.artist!.name!,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[300]),
                          ),
                          Text(
                            'Album • ${widget.album.year}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.download, size: 32, color: Colors.white),
                      const Icon(Icons.playlist_add,
                          size: 32, color: Colors.white),
                      GestureDetector(
                        onTap: () {
                          if (value.currentAlbumId != null &&
                              value.currentAlbumId!.toInt() ==
                                  widget.album.id!) {
                            value.pauseOrResume();
                          } else {
                            value.currentAlbumId = widget.album.id;
                            value.goToTrack(widget.album.tracks!, 0, context);
                          }
                        },
                        child: value.isPlaying &&
                                value.currentAlbumId != null &&
                                value.currentAlbumId!.toInt() ==
                                    widget.album.id!
                            ? const Icon(Icons.pause,
                                size: 32, color: Colors.white)
                            : const Icon(Icons.play_arrow,
                                size: 32, color: Colors.white),
                      ),
                      const Icon(Icons.more_vert,
                          size: 32, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = widget.album.tracks![index];
                return GestureDetector(
                  onTap: () {
                    value.goToTrack(widget.album.tracks!, index, context);
                  },
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    title: Text(
                      track.name!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      widget.album.artist!.name!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                );
              },
              childCount: widget.album.tracks!.length,
            ),
          ),
        ],
      ),
    ));
  }
}
