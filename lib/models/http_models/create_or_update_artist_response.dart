import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';

class CreateOrUpdateArtistResponse extends ResponseBase {
  Artist? data;

  CreateOrUpdateArtistResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  CreateOrUpdateArtistResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = Artist.fromJson(json["data"]);
    }
    success = json['success'];
    message = json['message'];
  }
}
