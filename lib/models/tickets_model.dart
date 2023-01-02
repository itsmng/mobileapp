import 'dart:convert';

import 'package:mobileapp/api/api_mgmt.dart';

List<Tickets> postFromJson(String str) =>
    List<Tickets>.from(json.decode(str).map((x) => Tickets.fromMap(x)));

class Tickets {
  String? date;
  int? status;
  String? timeToResolve;

  final apiMgmt = ApiMgmt();

  Tickets({
    this.date,
    this.status,
    this.timeToResolve,
  });

  factory Tickets.fromMap(Map<String, dynamic> json) {
    return Tickets(
      date: json["date"],
      status: json["status"],
      timeToResolve: json["time_to_resolve"],
    );
  }

  Future<List<Tickets>> fetchTicketsData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<Tickets>((json) => Tickets.fromMap(json)).toList();
  }
}
