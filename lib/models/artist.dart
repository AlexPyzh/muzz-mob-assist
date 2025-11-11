import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class Artist {
  int? id;
  String? name;
  String? imageUrl;
  List<Album>? albums;
  List<Track>? tracks;
  List<CategoryMuz>? categories;
  String? about;
  int? userId;
  User? user;
  bool? visible;
  bool? deleted;
  List<History>? histories;

  Artist({
    this.id,
    this.name,
    this.imageUrl,
    this.albums,
    this.tracks,
    this.categories,
    this.about,
    this.userId,
    this.user,
    this.visible,
    this.deleted,
    this.histories,
  });

  // Artist.fromJson(Map<String, dynamic> json) {
  //   id = json['id'] ?? 0;
  //   name = json['name'] ?? '';
  //   imageUrl = json['imageUrl'] ?? '';
  //   if (json['albums'] != null) {
  //     albums = <Album>[];
  //     json['albums'].forEach((v) {
  //       if (v != null) albums!.add(Album.fromJson(v));
  //     });
  //   }
  //   if (json['tracks'] != null) {
  //     tracks = <Track>[];
  //     json['tracks'].forEach((v) {
  //       if (v != null) tracks!.add(Track.fromJson(v));
  //     });
  //   }
  //   if (json['categories'] != null) {
  //     categories = <CategoryMuz>[];
  //     json['categories'].forEach((v) {
  //       if (v != null) categories!.add(CategoryMuz.fromJson(v));
  //     });
  //   }
  //   about = json['about'] ?? '';
  //   userId = json['userId'] ?? 0;
  //   user = json['user'] != null ? User.fromJson(json['user']) : User();
  //   visible = json['visible'];
  //   deleted = json['deleted'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['imageUrl'] = this.imageUrl;
  //   // if (this.albums != null) {
  //   //   data['albums'] = this.albums!.map((v) => v.toJson()).toList();
  //   // }
  //   if (this.tracks != null) {
  //     data['tracks'] = this.tracks!.map((v) => v.toMap()).toList();
  //   }
  //   return data;
  // }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      albums: json["albums"] == null
          ? []
          : List<Album>.from(json["albums"]!.map((x) => Album.fromJson(x))),
      tracks: json["tracks"] == null
          ? []
          : List<Track>.from(json["tracks"]!.map((x) => Track.fromJson(x))),
      categories: json["categories"] == null
          ? []
          : List<CategoryMuz>.from(
              json["categories"]!.map((x) => CategoryMuz.fromJson(x))),
      about: json["about"] ?? "",
      userId: json["userId"] ?? 0,
      user: json["user"] == null ? User() : User.fromJson(json["userId"]),
      visible: json["visible"] as bool?,
      deleted: json["deleted"] as bool?,
      histories: json["histories"] == null
          ? []
          : List<History>.from(
              json["histories"]!.map((x) => History.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "name": name ?? "",
        "imageUrl": imageUrl ?? "",
        "albums": albums == null ? [] : albums!.map((x) => x.toJson()).toList(),
        "tracks":
            tracks == null ? [] : tracks!.map((x) => x.toJsonNoId()).toList(),
        "categories": categories == null
            ? []
            : categories!.map((x) => x.toJson()).toList(),
        "about": about ?? "",
        "userId": userId,
        "user": user,
        "visible": visible ?? false,
        "deleted": deleted ?? false,
        "histories":
            histories == null ? [] : histories!.map((x) => x.toJson()).toList(),
      };
}
