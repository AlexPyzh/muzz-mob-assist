import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';

class LoginResponse extends ResponseBase {
  LoginResponse({
    this.data,
    super.success,
    super.message,
  });

  String? data;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    success = json['success'];
    message = json['message'];
  }
}
