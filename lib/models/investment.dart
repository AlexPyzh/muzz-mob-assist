import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/models/user.dart';

class Investment {
  Investment({
    this.id,
    this.userId,
    this.user,
    this.trackId,
    this.track,
    this.boughtPercent,
  });

  int? id;
  int? userId;
  User? user;
  int? trackId;
  Track? track;
  double? boughtPercent;

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      trackId: json["trackId"] ?? 0,
      track: json["track"] == null ? null : Track.fromJson(json["track"]),
      boughtPercent:
          json["boughtPercent"] == null ? null : json["boughtPercent"] + .0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "userId": userId,
        "user": user,
        "trackId": trackId,
        "track": track?.toJson(),
        "boughtPercent": boughtPercent,
      };

  Map<String, dynamic> toJsonNoId() {
    var invesment = toJson();
    invesment.remove("id");
    return invesment;
  }
}
