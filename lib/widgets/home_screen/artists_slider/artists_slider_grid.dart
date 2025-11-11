import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/config/app_scroll_behavior.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/artists_slider/artists_slider_item.dart';
import 'package:provider/provider.dart';

class ArtistsSliderGrid extends StatefulWidget {
  const ArtistsSliderGrid({
    super.key,
    required this.artists,
    this.rowCount = 2,
  });

  final List<Artist> artists;
  final int rowCount;

  @override
  State<ArtistsSliderGrid> createState() => _ArtistsSliderGridState();
}

class _ArtistsSliderGridState extends State<ArtistsSliderGrid> {
  late final dynamic trackListProvider;

  @override
  Widget build(BuildContext context) {
    double heght = (170 * widget.rowCount).toDouble();

    return SizedBox(
      width: double.infinity,
      height: heght,
      child: ScrollConfiguration(
        behavior: AppScrollBehavior(),
        child: Consumer<TrackListProvider>(
          builder: (context, value, child) => GridView.builder(
            itemCount: widget.artists.length,
            padding: const EdgeInsets.only(left: mainLeftMargin),
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              crossAxisCount: widget.rowCount,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Artist artist = widget.artists[index];
              return ArtistsSliderItem(
                artist: artist,
                path: artistScreenPath,
              );
            },
          ),
        ),
      ),
    );
  }
}
