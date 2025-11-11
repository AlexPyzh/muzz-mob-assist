import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/screens/album_list_screen.dart';
import 'package:muzzbirzha_mobile/screens/single_list_screen.dart';
import 'package:muzzbirzha_mobile/widgets/artist_screen/albums_grid.dart';
import 'package:muzzbirzha_mobile/widgets/artist_screen/artist_most_liked_title.dart';
import 'package:muzzbirzha_mobile/widgets/artist_screen/singles_grid.dart';
import 'package:muzzbirzha_mobile/widgets/track_list/track_list_item.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({
    required this.artistId,
    super.key,
  });
  final int artistId;

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

// Константы для отступов
class _ArtistScreenSpacing {
  static const double horizontalPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double titleBottomSpacing = 10.0;
  static const double afterAboutSpacing = 16.0;
  static const double bottomSpacing = 80.0;
}

class _ArtistScreenState extends State<ArtistScreen> {
  final _muzzClient = MuzzClient();
  Future<Artist>? _artist;
  Future<List<Track>>? _mostLikedArtistTracks;
  Future<List<Album>>? _albums;
  Future<List<Track>>? _singles;

  @override
  void initState() {
    super.initState();
    loadArtist();
    loadMostLikedTracks();
    loadAlbums();
    loadSingles();
  }

  Future loadArtist() async {
    _artist = _muzzClient.getArtistById(widget.artistId);
  }

  Future loadMostLikedTracks() async {
    _mostLikedArtistTracks =
        _muzzClient.getMostLikedArtistTracks(widget.artistId);
  }

  Future loadAlbums() async {
    _albums = _muzzClient.getAlbumsByArtistId(widget.artistId);
  }

  Future loadSingles() async {
    _singles = _muzzClient.getSinglesByArtistId(widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Artist>(
        future: _artist,
        builder: (context, artistSnapshot) {
          if (!artistSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final artist = artistSnapshot.data!;
          return CustomScrollView(
            slivers: [
              // Artist Header
              SliverAppBar(
                centerTitle: false,
                pinned: true,
                expandedHeight: 280,
                automaticallyImplyLeading: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsetsDirectional.only(
                      start: _ArtistScreenSpacing.horizontalPadding,
                      bottom: 16,
                      end: _ArtistScreenSpacing.horizontalPadding),
                  title: Text(artist.name ?? ''),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (artist.imageUrl != null)
                        SafeNetworkImage(
                          imageUrl: artist.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // About Section
              if (artist.about != null && artist.about!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      _ArtistScreenSpacing.horizontalPadding,
                      _ArtistScreenSpacing.sectionSpacing,
                      _ArtistScreenSpacing.horizontalPadding,
                      _ArtistScreenSpacing.afterAboutSpacing,
                    ),
                    child: Text(
                      artist.about!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              // Most Liked Tracks Section
              FutureBuilder<List<Track>>(
                future: _mostLikedArtistTracks,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  final tracks = snapshot.data!;
                  final displayedTracks =
                      tracks.length > 5 ? tracks.sublist(0, 5) : tracks;
                  return SliverPadding(
                    padding: EdgeInsets.only(
                      top: _ArtistScreenSpacing.sectionSpacing,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: _ArtistScreenSpacing.horizontalPadding,
                                right: _ArtistScreenSpacing.horizontalPadding,
                                bottom: _ArtistScreenSpacing.titleBottomSpacing,
                              ),
                              child: ArtistMostLikedTitle(
                                title: 'Most liked tracks',
                                tracks: tracks,
                              ),
                            );
                          }
                          final track = displayedTracks[index - 1];
                          return Consumer<TrackListProvider>(
                            builder: (context, value, _) => TrackListItem(
                              track: track,
                              goToTrack: () =>
                                  value.goToTrack(tracks, index - 1, context),
                            ),
                          );
                        },
                        childCount: displayedTracks.length + 1,
                      ),
                    ),
                  );
                },
              ),
              // Albums Section
              SliverToBoxAdapter(
                child: FutureBuilder<List<Album>>(
                  future: _albums,
                  builder: (context, albumSnap) {
                    if (!albumSnap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        left: _ArtistScreenSpacing.horizontalPadding,
                        right: _ArtistScreenSpacing.horizontalPadding,
                        top: _ArtistScreenSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    _ArtistScreenSpacing.titleBottomSpacing),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlbumListScreen(
                                      appBarTitle: 'Albums',
                                      albums: albumSnap.data!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Albums',
                                style: MuzzTheme.sectionTitleStyle,
                              ),
                            ),
                          ),
                          AlbumsGrid(albums: albumSnap.data!),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Singles Section
              SliverToBoxAdapter(
                child: FutureBuilder<List<Track>>(
                  future: _singles,
                  builder: (context, singlesSnap) {
                    if (!singlesSnap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (singlesSnap.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        left: _ArtistScreenSpacing.horizontalPadding,
                        right: _ArtistScreenSpacing.horizontalPadding,
                        top: _ArtistScreenSpacing.sectionSpacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    _ArtistScreenSpacing.titleBottomSpacing),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleListScreen(
                                      appBarTitle: 'Singles',
                                      singles: singlesSnap.data!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Singles',
                                style: MuzzTheme.sectionTitleStyle,
                              ),
                            ),
                          ),
                          SinglesGrid(singles: singlesSnap.data!),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Spacing
              SliverToBoxAdapter(
                child: SizedBox(height: _ArtistScreenSpacing.bottomSpacing),
              ),
            ],
          );
        },
      ),
    );
  }
}
