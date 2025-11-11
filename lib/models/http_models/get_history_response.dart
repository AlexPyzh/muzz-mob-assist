import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class GetHistoryResponse extends ResponseBase {
  List<History> data = [];

  GetHistoryResponse({
    required this.data,
    super.success,
    super.message,
  });

  GetHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data.add(History.fromJson(t)));
    }
    success = json['success'];
    message = json['message'];
  }
}
