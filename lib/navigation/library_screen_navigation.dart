import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/screens/album_screen.dart';
import 'package:muzzbirzha_mobile/screens/library_screen.dart';
import 'package:muzzbirzha_mobile/screens/playlists_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/personal_pl_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_artist_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_create_artist_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_add_or_edit_album/studio_add_or_edit_album_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_add_or_edit_single/studio_add_or_edit_single_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_list_albums_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_list_singles_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_screen.dart';
import 'package:muzzbirzha_mobile/screens/track_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/artist_screen.dart';
import 'package:provider/provider.dart';

class LibraryScreenNavigation extends StatefulWidget {
  const LibraryScreenNavigation({super.key});

  @override
  State<LibraryScreenNavigation> createState() =>
      _LibraryScreenNavigationState();
}

class _LibraryScreenNavigationState extends State<LibraryScreenNavigation> {
  GlobalKey<NavigatorState> libraryScreenNavigatorKey =
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
        key: libraryScreenNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              if (settings.name == "/history_tracks") {
                return TrackListScreen(
                    appBarTitle: "You listened",
                    tracks: settings.arguments as List<Track>);
              }
              if (settings.name == "/liked_tracks") {
                return TrackListScreen(
                    appBarTitle: "You like",
                    tracks: settings.arguments as List<Track>);
              }
              if (settings.name == "/personal_playlists") {
                return PersonalPlListScreen(
                    appBarTitle: "Your personal playlists",
                    playlists: settings.arguments as List<Playlist>);
              }
              if (settings.name == "/public_playlists") {
                return PlaylistsListScreen(
                    appBarTitle: "Playlists you shared",
                    playlists: settings.arguments as List<Playlist>);
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
              if (settings.name == "/studio") {
                return const StudioScreen();
              }
              if (settings.name == studioArtistScreenPath) {
                final artistId = settings.arguments as int;
                return StudioArtistScreen(
                  artistId: artistId,
                );
              }
              if (settings.name == studioCreateArtistScreenPath) {
                return const StudioCreateArtistScreen();
              }
              if (settings.name == studioArtistAlbumsScreenPath) {
                return const StudioListAlbumsScreen();
              }
              if (settings.name == studioArtistSinglesScreenPath) {
                return const StudioListSinglesScreen();
              }
              if (settings.name == studioAddOrEditSingleScreenPath) {
                final track = settings.arguments as Track;
                return StudioAddOrEditSingleScreen(
                  track: track,
                );
              }
              if (settings.name == studioAddOrEditAlbumScreenPath) {
                final album = settings.arguments as Album;
                return StudioAddOrEditAlbumScreen(
                  album: album,
                );
              }
              return const LibraryScreen();
            },
          );
        });
  }
}
