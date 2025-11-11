import 'dart:convert';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class History {
  int? id;
  int? userId;
  User? user;
  int? trackId;
  Track? track;
  int? artistId;
  Artist? artist;
  int? albumId;
  Album? album;
  int? playlistId;
  Playlist? playlist;
  DateTime? timeStamp;
  bool? liked;
  bool? invested;

  History({
    this.id,
    this.userId,
    this.user,
    this.trackId,
    this.track,
    this.artistId,
    this.artist,
    this.albumId,
    this.album,
    this.playlistId,
    this.playlist,
    this.timeStamp,
    this.liked,
    this.invested,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      user: json["user"] == null ? User() : User.fromJson(json["user"]),
      trackId: json["trackId"] ?? 0,
      track: json["track"] == null ? Track() : Track.fromJson(json["track"]),
      artistId: json["artistId"],
      artist:
          json["artist"] == null ? Artist() : Artist.fromJson(json["artist"]),
      albumId: json["albumId"] ?? 0,
      album: json["album"] == null ? Album() : Album.fromJson(json["album"]),
      playlistId: json["playlistId"] ?? 0,
      playlist: json["playlist"] == null
          ? Playlist()
          : Playlist.fromJson(json["playlist"]),
      timeStamp: DateTime.tryParse(json["timeStamp"] ?? ""),
      liked: json["liked"] as bool?,
      invested: json["invested"] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "userId": userId,
        "user": user,
        "trackId": trackId,
        "track": track?.toJsonNoId(),
        "artistId": artistId,
        "artist": artist?.toJson(),
        "albumId": albumId,
        "album": album?.toJson(),
        "playlistId": playlistId,
        "playlist": playlist?.toJson(),
        "timeStamp": timeStamp?.toUtc().toIso8601String(),
        "liked": liked ?? false,
        "invested": invested ?? false,
      };
}
