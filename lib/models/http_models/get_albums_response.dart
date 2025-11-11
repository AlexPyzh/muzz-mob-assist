import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';

class GetAlbumsResponse extends ResponseBase {
  List<Album> data = [];

  GetAlbumsResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  GetAlbumsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((a) => data.add(Album.fromJson(a)));
    }
    success = json['success'];
    message = json['message'];
  }
}
