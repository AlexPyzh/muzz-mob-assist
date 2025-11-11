import 'package:intl/intl.dart';
import 'package:muzzbirzha_mobile/models/fin_info.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';
import 'package:muzzbirzha_mobile/models/user_reaction.dart';

class Track {
  Track({
    this.id,
    this.name,
    this.about,
    this.imageUrl,
    this.artistId,
    this.artist,
    this.albumId,
    this.album,
    this.albumOrder,
    this.categories,
    this.playlists,
    this.featured,
    this.streamingUrl,
    this.userReactions,
    this.isSingle,
    this.year,
    this.visible,
    this.deleted,
    this.editing,
    this.isNew,
    this.histories,
    this.created,
    this.finInfo,
    this.investments,
  });

  int? id;
  String? name;
  String? about;
  String? imageUrl;
  int? artistId;
  Artist? artist;
  int? albumId;
  Album? album;
  int? albumOrder;
  List<CategoryMuz>? categories;
  List<Playlist>? playlists;
  bool? featured;
  String? streamingUrl;
  List<UserReaction>? userReactions;
  bool? isSingle;
  int? year;
  bool? visible;
  bool? deleted;
  bool? editing;
  bool? isNew;
  List<History>? histories;
  DateTime? created;
  FinInfo? finInfo;
  List<Investment>? investments;

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      about: json["about"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      artistId: json["artistId"] ?? 0,
      artist:
          json["artist"] == null ? Artist() : Artist.fromJson(json["artist"]),
      albumId: json["albumId"] ?? 0,
      album: json["album"] == null ? Album() : Album.fromJson(json["album"]),
      albumOrder: json["albumOrder"] ?? 0,
      categories: json["categories"] == null
          ? []
          : List<CategoryMuz>.from(
              json["categories"]!.map((x) => CategoryMuz.fromJson(x))),
      playlists: json["playlists"] == null
          ? []
          : List<Playlist>.from(
              json["playlists"]!.map((x) => Playlist.fromJson(x))),
      featured: json["featured"] ?? false,
      streamingUrl: json["streamingUrl"] ?? "",
      userReactions: json["userReactions"] == null
          ? []
          : List<UserReaction>.from(
              json["userReactions"]!.map((x) => UserReaction.fromJson(x))),
      isSingle: json["isSingle"] as bool?,
      year: json["year"] as int?,
      visible: json["visible"] as bool?,
      deleted: json["deleted"] as bool?,
      editing: json["editing"] as bool?,
      isNew: json["isNew"] as bool?,
      histories: json["histories"] == null
          ? []
          : List<History>.from(
              json["histories"]!.map((x) => History.fromJson(x))),
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      finInfo:
          json["finInfo"] == null ? null : FinInfo.fromJson(json["finInfo"]),
      investments: json["investments"] == null
          ? []
          : List<Investment>.from(
              json["investments"]!.map((x) => Investment.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "about": about,
        "imageUrl": imageUrl,
        "artistId": artistId,
        "artist": artist?.toJson(),
        "albumId": albumId,
        "album": album?.toJson(),
        "albumOrder": albumOrder,
        "categories": categories == null
            ? []
            : categories!.map((x) => x.toJson()).toList(),
        "playlists":
            playlists == null ? [] : playlists!.map((x) => x.toJson()).toList(),
        "featured": featured ?? false,
        "streamingUrl": streamingUrl,
        "userReactions":
            userReactions == null ? [] : userReactions!.map((x) => x).toList(),
        "isSingle": isSingle ?? false,
        "year": year,
        "visible": visible ?? false,
        "deleted": deleted ?? false,
        "editing": editing ?? false,
        "isNew": isNew ?? false,
        "histories":
            histories == null ? [] : histories!.map((x) => x.toJson()).toList(),
        //"created": created?.toIso8601String(),
        "created": created == null
            ? null
            : "${DateFormat('yyyy-MM-ddThh:mm:ss.ms').format(created!).toString()}Z",
        "finInfo": finInfo?.toJson(),
        "investments": investments == null
            ? []
            : investments!.map((x) => x.toJson()).toList(),
      };

  Map<String, dynamic> toJsonNoId() {
    var track = toJson();
    track.remove("id");
    return track;
  }
}
