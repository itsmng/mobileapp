import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class StateComputer {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  StateComputer({
    this.id,
    this.name,
  });

  factory StateComputer.fromMap(Map<String, dynamic> json) {
    return StateComputer(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<StateComputer>> fetchStateComputerData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed
        .map<StateComputer>((json) => StateComputer.fromMap(json))
        .toList();
  }

  getAllStateComputer() async {
    List<StateComputer> futureStateComputer;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllStateComputer);
    futureStateComputer = await fetchStateComputerData(apiResp);

    return futureStateComputer;
  }
}
