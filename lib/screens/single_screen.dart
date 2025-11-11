import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';

class SingleScreen extends StatefulWidget {
  const SingleScreen({
    super.key,
    required this.single,
  });

  final Track single;

  @override
  State<SingleScreen> createState() => _SingleScreenState();
}

class _SingleScreenState extends State<SingleScreen> {
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
                imageUrl: widget.single.imageUrl ?? '',
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
                      Flexible(
                        child: Text(
                          widget.single.name ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.single.artist?.imageUrl != null)
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, "/artist",
                              arguments: widget.single.artistId!),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.single.artist!.imageUrl!),
                            radius: 25,
                          ),
                        ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.single.artist?.name ?? '',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[300]),
                          ),
                          Text(
                            'Single • ${widget.single.year ?? ''}',
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
                          if (value.currentTrackIndex != null &&
                              value.currentTrack.id == widget.single.id!) {
                            value.pauseOrResume();
                          } else {
                            value.goToTrack([widget.single], 0, context);
                          }
                        },
                        child: value.isPlaying &&
                                value.currentTrackIndex != null &&
                                value.currentTrack.id == widget.single.id!
                            ? const Icon(Icons.pause,
                                size: 32, color: Colors.white)
                            : const Icon(Icons.play_arrow,
                                size: 32, color: Colors.white),
                      ),
                      const Icon(Icons.more_vert,
                          size: 32, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (widget.single.about != null &&
                      widget.single.about!.isNotEmpty) ...[
                    const Text(
                      'About',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.single.about!,
                      style: TextStyle(color: Colors.grey[300], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
