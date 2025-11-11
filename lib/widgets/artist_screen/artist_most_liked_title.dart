import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/screens/track_list_screen.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class ArtistMostLikedTitle extends StatelessWidget {
  const ArtistMostLikedTitle({
    super.key,
    required this.title,
    required this.tracks,
    //required this.navigationPath,
  });

  final String title;
  final List<Track> tracks;
  //final String navigationPath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, navigationPath);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TrackListScreen(appBarTitle: title, tracks: tracks),
          ),
        );
      },
      child: Text(
        title,
        style: MuzzTheme.sectionTitleStyle,
      ),
    );
  }
}
