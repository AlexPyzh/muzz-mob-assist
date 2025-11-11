import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/screens/album_screen.dart';
import 'package:muzzbirzha_mobile/screens/artist_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/artist_screen.dart';
import 'package:muzzbirzha_mobile/screens/home_screen.dart';
import 'package:muzzbirzha_mobile/screens/playlists_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/single_screen.dart';
import 'package:muzzbirzha_mobile/screens/track_list_screen.dart';
import 'package:provider/provider.dart';

class HomeScreenNavigation extends StatefulWidget {
  const HomeScreenNavigation({super.key});

  @override
  State<HomeScreenNavigation> createState() => _HomeScreenNavigationState();
}

class _HomeScreenNavigationState extends State<HomeScreenNavigation> {
  GlobalKey<NavigatorState> homeScreenNavigatorKey =
      GlobalKey<NavigatorState>();

  late final dynamic trackListProvider;

  @override
  void initState() {
    trackListProvider = Provider.of<TrackListProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeScreenNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == "/new_tracks") {
              final tracks = settings.arguments as List<Track>;
              // return FutureBuilder<List<Track>>(
              //     future: trackListProvider.newTracks,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState != ConnectionState.done) {
              //         return const SizedBox(
              //           height: 300,
              //           width: 300,
              //           child: CircularProgressIndicator(),
              //         );
              //       } else {
              //         return TrackListScreen(
              //           appBarTitle: "New tracks",
              //           tracks: snapshot.data!,
              //         );
              //       }
              //     });

              return TrackListScreen(
                appBarTitle: "New tracks",
                tracks: tracks,
              );
            }
            if (settings.name == "/most_liked_tracks") {
              return FutureBuilder<List<Track>>(
                  future: trackListProvider.mostLikedTracks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 300,
                        width: 300,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return TrackListScreen(
                        appBarTitle: "Most liked tracks",
                        tracks: snapshot.data!,
                      );
                    }
                  });
            }
            if (settings.name == "/playlists-list") {
              return FutureBuilder<List<Playlist>>(
                  future: trackListProvider.playlists,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 300,
                        width: 300,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return PlaylistsListScreen(
                        appBarTitle: recommendedPlaylistsAppBarTitle,
                        playlists: snapshot.data!,
                      );
                    }
                  });
            }
            if (settings.name == "/recommended-artists") {
              return FutureBuilder<List<Artist>>(
                  future: trackListProvider.artists,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ArtistListScreen(
                        appBarTitle: recommendedArtistsAppBarTitle,
                        artists: snapshot.data!,
                      );
                    }
                  });
            }
            if (settings.name == "/artist") {
              final artistId = settings.arguments as int;
              return ArtistScreen(
                artistId: artistId,
              );
            }
            if (settings.name == "/album") {
              final album = settings.arguments as Album;
              return AlbumScreen(
                album: album,
              );
            }
            if (settings.name == "/single") {
              final single = settings.arguments as Track;
              return SingleScreen(
                single: single,
              );
            }
            return const HomeScreen();
          },
        );
      },
    );
  }
}
