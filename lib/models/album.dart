import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/category_muz.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class Album {
  Album({
    this.id,
    this.name,
    this.artistId,
    this.artist,
    this.tracks,
    this.imageUrl,
    this.categories,
    this.year,
    this.description,
    this.visible,
    this.deleted,
    this.editing,
    this.isNew,
    this.histories,
    this.created,
  });

  int? id;
  String? name;
  int? artistId;
  Artist? artist;
  List<Track>? tracks;
  String? imageUrl;
  List<CategoryMuz>? categories;
  String? year;
  String? description;
  bool? visible;
  bool? deleted;
  bool? editing;
  bool? isNew;
  List<History>? histories;
  DateTime? created;

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        artistId: json["artistId"] ?? 0,
        artist:
            json["artist"] == null ? Artist() : Artist.fromJson(json["artist"]),
        tracks: json["tracks"] == null
            ? []
            : List<Track>.from(json["tracks"]!.map((x) => Track.fromJson(x))),
        imageUrl: json["imageUrl"] ?? "",
        categories: json["categories"] == null
            ? []
            : List<CategoryMuz>.from(
                json["categories"]!.map((x) => CategoryMuz.fromJson(x))),
        year: json["year"] ?? "",
        description: json["description"] ?? "",
        visible: json["visible"] as bool?,
        deleted: json["deleted"] as bool?,
        editing: json["editing"] as bool?,
        isNew: json["isNew"] as bool?,
        histories: json["histories"] == null
            ? []
            : List<History>.from(
                json["histories"]!.map((x) => History.fromJson(x))),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]));
  }

  Map<String, dynamic> toJson() => {
        //"id": id,
        "name": name,
        "artistId": artistId,
        "artist": artist?.toJson(),
        "tracks":
            tracks == null ? [] : tracks!.map((x) => x.toJsonNoId()).toList(),
        "imageUrl": imageUrl,
        "categories": categories == null
            ? []
            : categories!.map((x) => x.toJson()).toList(),
        "year": year ?? "",
        "description": description,
        "visible": visible ?? false,
        "deleted": deleted ?? false,
        "editing": editing ?? false,
        "isNew": isNew ?? false,
        "histories": histories == null ? [] : histories,
        "created": created == null
            ? null
            : "${DateFormat('yyyy-MM-ddThh:mm:ss.ms').format(created!).toString()}Z",
      };

  Map<String, dynamic> toJsonWithId() {
    var alb = toJson();
    alb.addAll({"id": id});
    return alb;
  }
}
