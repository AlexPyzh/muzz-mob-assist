import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class GetTrackResponse extends ResponseBase {
  Track data;

  GetTrackResponse({
    required this.data,
    super.success,
    super.message,
  });

  factory GetTrackResponse.fromJson(Map<String, dynamic> json) {
    return GetTrackResponse(
        data: json['data'] == null ? Track() : Track.fromJson(json['data']),
        success: json['success'] as bool?,
        message: json['message'] as String?);
  }
}
