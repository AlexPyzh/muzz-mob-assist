import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/config/app_scroll_behavior.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/tracks_slider/tracks_slider_item.dart';
import 'package:provider/provider.dart';

class TracksSliderGrid extends StatefulWidget {
  const TracksSliderGrid({
    super.key,
    required this.tracks,
    this.rowCount = 2,
  });

  final List<Track> tracks;
  final int rowCount;

  @override
  State<TracksSliderGrid> createState() => _TracksSliderGridState();
}

class _TracksSliderGridState extends State<TracksSliderGrid> {
  late final dynamic trackListProvider;

  @override
  Widget build(BuildContext context) {
    double heght = (150 * widget.rowCount).toDouble();

    return SizedBox(
      width: double.infinity,
      height: heght,
      child: ScrollConfiguration(
        behavior: AppScrollBehavior(),
        child: Consumer<TrackListProvider>(
          builder: (context, value, child) => GridView.builder(
            itemCount: widget.tracks.length,
            padding: const EdgeInsets.only(left: mainLeftMargin),
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //mainAxisSpacing: 2.0,
              //crossAxisSpacing: 2.0,
              crossAxisCount: widget.rowCount,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Track track = widget.tracks[index];
              return TracksSliderItem(
                  track: track,
                  goToTrack: () {
                    value.goToTrack(widget.tracks, index, context);
                  });
            },
          ),
        ),
      ),
    );
  }
}
