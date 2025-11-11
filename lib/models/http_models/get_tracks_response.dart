import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class GetTracksResponse extends ResponseBase {
  List<Track> data = [];

  GetTracksResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  GetTracksResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data.add(Track.fromJson(t)));
    }
    success = json['success'];
    message = json['message'];
  }
}
