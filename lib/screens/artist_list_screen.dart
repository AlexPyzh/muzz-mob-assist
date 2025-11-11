import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/config/app_scroll_behavior.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/artists_slider/artists_slider_item.dart';
import 'package:provider/provider.dart';

class ArtistListScreen extends StatelessWidget {
  const ArtistListScreen({
    required this.appBarTitle,
    required this.artists,
    super.key,
  });

  final String appBarTitle;
  final List<Artist> artists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: Consumer<TrackListProvider>(
              builder: (context, value, child) => GridView.builder(
                  itemCount: artists.length,
                  padding: const EdgeInsets.only(left: mainLeftMargin),
                  scrollDirection: Axis.vertical,
                  physics: const PageScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Artist artist = artists[index];
                    return ArtistsSliderItem(
                      artist: artist,
                      path: artistScreenPath,
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
