import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class CreateOrUpdateTrackResponse extends ResponseBase {
  Track? data;

  CreateOrUpdateTrackResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  CreateOrUpdateTrackResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = Track.fromJson(json["data"]);
    }
    success = json['success'];
    message = json['message'];
  }
}
