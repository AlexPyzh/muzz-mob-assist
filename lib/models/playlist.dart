import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class Playlist {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  List<Track>? tracks;
  bool? public;
  int? userId;
  User? user;
  DateTime? created;
  List<History>? histories;

  Playlist({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.tracks,
    this.public,
    this.userId,
    this.user,
    this.created,
    this.histories,
  });

  // Playlist.fromJson(Map<String, dynamic> json) {
  //   id = json['id'] ?? 0;
  //   name = json['name'] ?? '';
  //   description = json['description'] ?? '';
  //   if (json['tracks'] != null) {
  //     tracks = <Track>[];
  //     json['tracks'].forEach((v) {
  //       if (v != null) tracks!.add(Track.fromJson(v));
  //     });
  //   }
  //   imageUrl = json['imageUrl'] ?? '';
  //   public = json['public'];
  //   userId = json['userId'] ?? 0;
  //   user = json['user'] != null ? User.fromJson(json) : User();
  //   created = DateTime.parse(json['created']);
  // }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      tracks: json["tracks"] == null
          ? []
          : List<Track>.from(json["tracks"]!.map((x) => Track.fromJson(x))),
      public: json["public"] as bool,
      userId: json["userId"] ?? 0,
      user: json["user"] == null ? User() : User.fromJson(json["user"]),
      created: DateTime.tryParse(json["created"] ?? ""),
      histories: json["histories"] == null
          ? []
          : List<History>.from(
              json["histories"]!.map((x) => History.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "name": name ?? "",
        "description": description ?? "",
        "imageUrl": imageUrl ?? "",
        "tracks":
            tracks == null ? [] : tracks!.map((x) => x.toJsonNoId()).toList(),
        "public": public,
        "userId": userId,
        "user": null,
        "created": created?.toUtc().toIso8601String(),
        "histories":
            histories == null ? [] : histories!.map((x) => x.toJson()).toList(),
      };
}
