import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/track.dart';

class GetArtistResponse extends ResponseBase {
  Artist data;

  GetArtistResponse({
    required this.data,
    super.success,
    super.message,
  });

  factory GetArtistResponse.fromJson(Map<String, dynamic> json) {
    return GetArtistResponse(
        data: json['data'] == null ? Artist() : Artist.fromJson(json['data']),
        success: json['success'] as bool?,
        message: json['message'] as String?);
  }
}
