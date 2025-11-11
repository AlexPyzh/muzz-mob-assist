import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/history.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';

class TrackListProvider extends ChangeNotifier {
  TrackListProvider() {
    listenToDuration();
  }

  AuthProvider? authProvider;

  final muzzClient = MuzzClient();
  List<Track> _currentTrackList = [];
  int? _currentTrackIndex;
  int? _currentArtistId;
  int? _currentAlbumId;
  BuildContext? _buildContext;

  Future<List<Track>>? _mostLikedTracks;
  Future<List<Track>>? _newTracks;
  Future<List<Playlist>>? _playlists;
  Future<List<Artist>>? _artists;

  final _player = AudioPlayer();
  Duration? _currenDuration = Duration.zero;
  Duration? _totalDuration = Duration.zero;

  final MiniplayerController _miniplayerController = MiniplayerController();

  bool _isPlaying = false;

  void play() async {
    final String streamingUrl =
        _currentTrackList[_currentTrackIndex!].streamingUrl.toString();
    _player.stop();
    _player.setAudioSource(AudioSource.uri(Uri.parse(streamingUrl)));
    _player.play();
    await _player.setVolume(1.0);
    _isPlaying = true;
    //_currentArtistId = _currentTrackList[_currentTrackIndex!].artistId;
    notifyListeners();
  }

  void stop() {
    _player.stop();
  }

  void pause() {
    _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _player.play();
    _isPlaying = true;
  }

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      if (_currenDuration == Duration.zero) {
        play();
      } else {
        resume();
      }
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _player.seek(position);
  }

  void playNextTrack() {
    if (_currentTrackIndex != null) {
      if (_currentTrackIndex! < trackList.length - 1) {
        _currentTrackIndex = _currentTrackIndex! + 1;
        stop();
        play();
      } else {
        _currentTrackIndex = 0;
        stop();
        play();
      }
    }
  }

  void playPreviosTrack() async {
    if (_currenDuration!.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentTrackIndex! > 0) {
        _currentTrackIndex = _currentTrackIndex! - 1;
        stop();
        play();
      } else {
        _currentTrackIndex = trackList.length - 1;
        stop();
        play();
      }
    }
  }

  void listenToDuration() {
    _player.durationStream.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _player.positionStream.listen((newPosition) {
      _currenDuration = newPosition;
      notifyListeners();
    });

    _player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        playNextTrack();
      }
    });
  }

// Getters

  Track get currentTrack => _currentTrackList[_currentTrackIndex!];
  List<Track> get trackList => _currentTrackList;

  Future<List<Track>>? get mostLikedTracks {
    if (_mostLikedTracks == null) {
      loadMostLikedTracks();
    }

    return _mostLikedTracks;
  }

  Future<List<Track>>? get newTracks {
    //if (_newTracks == null) {
    _newTracks = null;
    loadNewTracks();
    //}

    return _newTracks;
  }

  Future<List<Playlist>>? get playlists {
    if (_playlists == null) {
      loadPlaylists();
    }

    return _playlists;
  }

  Future<List<Artist>>? get artists {
    if (_artists == null) {
      loadArtists();
    }

    return _artists;
  }

  int? get currentTrackIndex => _currentTrackIndex;
  int? get currentArtistId => _currentArtistId;
  int? get currentAlbumId => _currentAlbumId;
  bool get isPlaying => _isPlaying;
  Duration? get currentDurartion => _currenDuration;
  Duration? get totalDurartion => _totalDuration;
  MiniplayerController? get miniPlayerController => _miniplayerController;
  BuildContext get buildContext => _buildContext!;

// Setters

  set currentTrackIndex(int? newIndex) {
    _currentTrackIndex = newIndex;

    if (newIndex != null) {
      play();
    } else {
      stop();
    }
    notifyListeners();
  }

  set trackList(List<Track> tracks) {
    _currentTrackList = tracks;
    //notifyListeners();
  }

  set buildContext(BuildContext buildContext) {
    _buildContext = buildContext;
  }

  set currentAlbumId(int? albumId) {
    _currentAlbumId = albumId;
  }

  set currentArtistId(int? artistId) {
    _currentArtistId = artistId;
  }

  // Functions
  void goToTrack(
      List<Track> tracks, int trackIndex, BuildContext buildContext) {
    if (tracks != _currentTrackList) {
      _currentTrackList = tracks;
    }

    _currentTrackIndex = trackIndex;
    _buildContext = buildContext;

    //_miniplayerController.animateToHeight(state: PanelState.MIN);

    createAuthProviderInstanse();
    muzzClient.addHistory(History(
      userId: authProvider!.loggedInUser.id,
      trackId: currentTrack.id,
      timeStamp: DateTime.now(),
    ));
    play();
  }

  Future loadMostLikedTracks() async {
    _mostLikedTracks = muzzClient.getMostLikedTracks();
    //notifyListeners();
  }

  Future loadNewTracks() async {
    _newTracks = muzzClient.getTracks();
    //notifyListeners();
  }

  Future loadPlaylists() async {
    _playlists = muzzClient.getPlaylists();
  }

  Future loadArtists() async {
    _artists = muzzClient.getArtists();
  }

  void createAuthProviderInstanse() {
    if (_buildContext != null && authProvider == null) {
      authProvider = Provider.of<AuthProvider>(_buildContext!, listen: false);
    }
  }
}
