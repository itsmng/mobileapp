import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class ITILCategory {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  ITILCategory({
    this.id,
    this.name,
  });

  factory ITILCategory.fromMap(Map<String, dynamic> json) {
    return ITILCategory(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<ITILCategory>> fetchItilCategoriesData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed
        .map<ITILCategory>((json) => ITILCategory.fromMap(json))
        .toList();
  }

  getAllItilCategories() async {
    List<ITILCategory> futureItilCategories;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllItilCategories);
    futureItilCategories = await fetchItilCategoriesData(apiResp);

    return futureItilCategories;
  }
}
