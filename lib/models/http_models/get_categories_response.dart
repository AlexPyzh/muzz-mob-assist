import 'package:muzzbirzha_mobile/models/category_muz.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';

class GetCategoriesResponse extends ResponseBase {
  List<CategoryMuz>? data = [];

  GetCategoriesResponse({
    this.data,
    super.success,
    super.message,
  });

  List<CategoryMuz>? get categories => data;

  GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((t) => data!.add(CategoryMuz.fromJsonIdName(t)));
    }
    success = json['success'] ?? "";
    message = json['message'] ?? "";
  }
}
