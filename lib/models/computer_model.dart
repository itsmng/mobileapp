import 'dart:convert';

import 'package:mobileapp/api/api_mgmt.dart';

List<Computer> postFromJson(String str) =>
    List<Computer>.from(json.decode(str).map((x) => Computer.fromMap(x)));

class Computer {
  String? status;

  final apiMgmt = ApiMgmt();

  Computer({
    this.status,
  });

  factory Computer.fromMap(Map<String, dynamic> json) {
    if (json["states_id"] == 0) {
      return Computer(
        status: "No status",
      );
    }
    return Computer(
      status: json["states_id"].toString(),
    );
  }

  Future<List<Computer>> fetchComputerData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<Computer>((json) => Computer.fromMap(json)).toList();
  }
}
