import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class CategoryMuz {
  CategoryMuz({
    this.id,
    this.name,
    this.tracks,
    this.albums,
    this.artists,
    this.url,
    this.visible,
    this.deleted,
    this.editing,
    this.isNew,
  });

  int? id;
  String? name;
  List<Track>? tracks;
  List<Album>? albums;
  List<Artist>? artists;
  String? url;
  bool? visible;
  bool? deleted;
  bool? editing;
  bool? isNew;

  factory CategoryMuz.fromJson(Map<String, dynamic> json) {
    return CategoryMuz(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      tracks: json["tracks"] == null
          ? []
          : List<Track>.from(json["tracks"]!.map((x) => Track.fromJson(x))),
      albums: json["albums"] == null
          ? []
          : List<Album>.from(json["albums"]!.map((x) => Album.fromJson(x))),
      artists: json["artists"] == null
          ? []
          : List<Artist>.from(json["albums"]!.map((x) => Artist.fromJson(x))),
      url: json["url"] ?? "",
      visible: json["visible"] as bool?,
      deleted: json["deleted"] as bool?,
      editing: json["editing"] as bool?,
      isNew: json["isNew"] as bool?,
    );
  }

  factory CategoryMuz.fromJsonIdName(Map<String, dynamic> json) {
    return CategoryMuz(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      tracks: [],
      albums: [],
      artists: [],
      url: "",
      visible: json["visible"] as bool?,
      deleted: json["deleted"] as bool?,
      editing: json["editing"] as bool?,
      isNew: json["isNew"] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tracks": tracks!.map((x) => x?.toJsonNoId()).toList(),
        "albums": albums!.map((x) => x?.toJson()).toList(),
        "artists": artists!.map((x) => x?.toJson()).toList(),
        "url": url,
        "visible": visible,
        "deleted": deleted,
        "editing": editing,
        "isNew": isNew,
      };
}
