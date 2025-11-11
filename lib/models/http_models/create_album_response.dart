import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';

class CreateOrUpdateAlbumResponse extends ResponseBase {
  Album? data;

  CreateOrUpdateAlbumResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  CreateOrUpdateAlbumResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = Album.fromJson(json["data"]);
    }
    success = json['success'];
    message = json['message'];
  }
}
