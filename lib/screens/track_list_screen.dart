import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/widgets/track_list/track_list_view.dart';

class TrackListScreen extends StatelessWidget {
  const TrackListScreen(
      {super.key, required this.appBarTitle, required this.tracks});

  final String appBarTitle;
  final List<Track> tracks;

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
        body: TrackListView(
          trackList: tracks,
        )

        //bottomNavigationBar: const MainBottomNavigationBar(),
        );
  }
}
