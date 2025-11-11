import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';

class RegResponse extends ResponseBase {
  RegResponse({
    this.data,
    super.success,
    super.message,
  });

  int? data = 0;

  RegResponse.fromJson(Map<String, dynamic> json) {
    data = int.parse(json['data'].toString());
    success = json['success'];
    message = json['message'];
  }
}
