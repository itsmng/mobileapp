import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class Entity {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  Entity({
    this.id,
    this.name,
  });

  factory Entity.fromMap(Map<String, dynamic> json) {
    return Entity(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<Entity>> fetchEntitiesData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed
        .map<Entity>((json) => Entity.fromMap(json))
        .toList();
  }

  getAllEntities() async {
    List<Entity> futureEntities;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllEntities);
    futureEntities = await fetchEntitiesData(apiResp);

    return futureEntities;
  }
}
