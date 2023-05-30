import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class TicketUser {
  int? id;
  int? ticketsID;
  int? userID;

  final apiMgmt = ApiMgmt();

  TicketUser({
    this.id,
    this.ticketsID,
    this.userID,
  });

  factory TicketUser.fromMap(Map<String, dynamic> json) {
    return TicketUser(
      id: json["id"],
      ticketsID: json["tickets_id"],
      userID: json["users_id"],
    );
  }

  Future<List<TicketUser>> fetchTicketUsersData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<TicketUser>((json) => TicketUser.fromMap(json)).toList();
  }

  getAllTicketUsers() async {
    List<TicketUser> futureTicketUsers;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllTicketUsers);
    futureTicketUsers = await fetchTicketUsersData(apiResp);

    return futureTicketUsers;
  }
}
