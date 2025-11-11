import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final dynamic authProvider;
  final _muzzClient = MuzzClient();
  Future<List<History>>? _trackHistory;
  Future<List<Playlist>>? _userPlaylists;
  Future<List<Track>>? _userLikedTracks;

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadTrackHistory();
    loadUserPlaylists();
    loadUserLikedTracks();
    super.initState();
  }

  Future loadTrackHistory() async {
    _trackHistory =
        _muzzClient.getTrackHistoryByUserId(authProvider.loggedInUser.id);
  }

  Future loadUserPlaylists() async {
    _userPlaylists = _muzzClient.getUserPlaylists(authProvider.loggedInUser.id);
  }

  Future loadUserLikedTracks() async {
    _userLikedTracks =
        _muzzClient.getUserLikedTracks(authProvider.loggedInUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Library",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/studio");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MuzzTheme.studioPrimaryBg,
              foregroundColor: MuzzTheme.studioPrimaryText,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 36),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              elevation: 0,
            ),
            child: Text(
              "Studio",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: MuzzTheme.studioPrimaryText,
                  ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<History>>(
                future: _trackHistory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return TracksSlider(
                      title: "History",
                      tracks: snapshot.data!.map((h) => h.track!).toList(),
                      navigationPath: "/history_tracks",
                      rowCount: 1,
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<Track>>(
                future: _userLikedTracks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return TracksSlider(
                      title: "Liked tracks",
                      tracks: snapshot.data!,
                      navigationPath: "/liked_tracks",
                      rowCount: 1,
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<Playlist>>(
                future: _userPlaylists,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return PlaylistsSlider(
                      playlists: snapshot.data!,
                      title: "Personal playlists",
                      navigationPath: "/personal_playlists",
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<Playlist>>(
                future: _userPlaylists,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return PlaylistsSlider(
                      playlists: snapshot.data!,
                      title: "Public playlists",
                      navigationPath: "/public_playlists",
                    );
                  }
                },
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
