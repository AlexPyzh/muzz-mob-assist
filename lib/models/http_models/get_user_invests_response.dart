import 'package:muzzbirzha_mobile/models/http_models/response_base.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';

class GetUserInvestmentsResponse extends ResponseBase {
  List<Investment> data = [];

  GetUserInvestmentsResponse({
    required this.data,
    required super.success,
    required super.message,
  });

  GetUserInvestmentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data.add(Investment.fromJson(t)));
    }
    success = json['success'];
    message = json['message'];
  }
}
