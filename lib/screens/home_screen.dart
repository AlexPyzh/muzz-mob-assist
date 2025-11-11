import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final dynamic trackListProvider;

  @override
  void initState() {
    trackListProvider = Provider.of<TrackListProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const MainAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  FutureBuilder<List<Track>>(
                    future: trackListProvider.newTracks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox(
                          height: 300,
                          width: 300,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return TracksSlider(
                          title: newTracksAppBarTitle,
                          tracks: snapshot.data!,
                          navigationPath: "/new_tracks",
                          rowCount: 2,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<List<Track>>(
                    future: trackListProvider.mostLikedTracks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return TracksSlider(
                          title: mostLikedAppBarTitle,
                          tracks: snapshot.data!,
                          navigationPath: "/most_liked_tracks",
                          rowCount: 1,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<List<Playlist>>(
                      future: trackListProvider.playlists,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox(
                            height: 300,
                            width: 300,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return PlaylistsSlider(
                            title: recommendedPlaylistsAppBarTitle,
                            playlists: snapshot.data!,
                            rowCount: 1,
                            navigationPath: "/playlists-list",
                          );
                        }
                      }),
                  const SizedBox(height: 40),
                  FutureBuilder<List<Artist>>(
                    future: trackListProvider.artists,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox(
                          height: 300,
                          width: 300,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ArtistsSlider(
                          title: recommendedArtistsAppBarTitle,
                          artists: snapshot.data!,
                          rowCount: 1,
                          navigationPath: "/recommended-artists",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
