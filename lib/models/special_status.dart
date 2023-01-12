import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class SpecialStatus {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  SpecialStatus({
    this.id,
    this.name,
  });

  factory SpecialStatus.fromMap(Map<String, dynamic> json) {
    return SpecialStatus(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<SpecialStatus>> fetchSpecialStatusData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed
        .map<SpecialStatus>((json) => SpecialStatus.fromMap(json))
        .toList();
  }

  getAllSpecialStatus() async {
    List<SpecialStatus> futureSpecialStatus;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllSpecialStatus);
    futureSpecialStatus = await fetchSpecialStatusData(apiResp);

    return futureSpecialStatus;
  }
}
