import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class UpdateSource {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  UpdateSource({
    this.id,
    this.name,
  });

  factory UpdateSource.fromMap(Map<String, dynamic> json) {
    return UpdateSource(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<UpdateSource>> fetchUpdateSourceData(dynamic data) async {
    try {
      final parsed = json.decode(await data).cast<Map<String, dynamic>>();

      return parsed
        .map<UpdateSource>((json) => UpdateSource.fromMap(json))
        .toList();
    } catch (e) {
      return [];
    }
    
  }

  getAllUpdateSource() async {
    List<UpdateSource> futureUpdateSource;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetRootUpdateSource);
    futureUpdateSource = await fetchUpdateSourceData(apiResp);

    return futureUpdateSource;
  }
}
