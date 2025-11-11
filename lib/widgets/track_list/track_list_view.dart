import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/track_list/track_list_item.dart';
import 'package:provider/provider.dart';

class TrackListView extends StatefulWidget {
  const TrackListView({
    required this.trackList,
    super.key,
  });

  final List<Track> trackList;

  @override
  State<TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<TrackListView> {
  late final dynamic trackListProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackListProvider>(
      builder: ((context, value, child) {
        final List<Track> trackList = widget.trackList;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: trackList.length,
          itemBuilder: ((context, index) {
            final Track track = trackList[index];
            return TrackListItem(
              track: track,
              goToTrack: () {
                value.goToTrack(widget.trackList, index, context);
              },
            );
          }),
        );
      }),
    );
  }
}
