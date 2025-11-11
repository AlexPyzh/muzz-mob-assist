import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/widgets/track_list/track_list_view.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';

class PLaylistScreen extends StatelessWidget {
  const PLaylistScreen({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          playlist.name!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SafeNetworkImage(
            imageUrl: playlist.imageUrl!,
            height: MediaQuery.of(context).size.width > 350
                ? 300
                : MediaQuery.of(context).size.width - 6,
            width: MediaQuery.of(context).size.width > 350
                ? 300
                : MediaQuery.of(context).size.width - 6,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 14),
          Text(playlist.description!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 14),
          TrackListView(trackList: playlist.tracks!),
        ]),
      ),
    );
  }
}
