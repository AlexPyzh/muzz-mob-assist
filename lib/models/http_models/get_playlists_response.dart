import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';

class GetPlaylistsResponse extends ResponseBase {
  List<Playlist> data = [];

  GetPlaylistsResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  GetPlaylistsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data.add(Playlist.fromJson(t)));
    }
    success = json['success'];
    message = json['message'];
  }
}
