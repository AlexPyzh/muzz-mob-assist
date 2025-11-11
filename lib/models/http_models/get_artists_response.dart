import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class GetArtistsResponse extends ResponseBase {
  List<Artist>? data = [];

  GetArtistsResponse({
    this.data,
    super.success,
    super.message,
  });

  GetArtistsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data!.add(Artist.fromJson(t)));
    }
    success = json['success'];
    message = json['message'];
  }
}
