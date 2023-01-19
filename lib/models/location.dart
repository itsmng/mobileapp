import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class Location {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  Location({
    this.id,
    this.name,
  });

  factory Location.fromMap(Map<String, dynamic> json) {
    return Location(
      id: json["id"],
      name: json["completename"],
    );
  }

  Future<List<Location>> fetchLocationsData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<Location>((json) => Location.fromMap(json)).toList();
  }

  getAllLocations() async {
    List<Location> futureLocations;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllLocations);
    futureLocations = await fetchLocationsData(apiResp);

    return futureLocations;
  }
}
