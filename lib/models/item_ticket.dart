import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class ItemTicket {
  int? id;
  int? ticketsID;
  int? itemsID;
  String? itemsType;
  String? statusTicket;
  String? dateTicket;

  final apiMgmt = ApiMgmt();

  ItemTicket({
    this.id,
    this.ticketsID,
    this.itemsID,
    this.itemsType,
  });

  factory ItemTicket.fromMap(Map<String, dynamic> json) {
    try {
      return ItemTicket(
        id: json["id"],
        ticketsID: json["tickets_id"],
        itemsID: json["items_id"],
        itemsType: json["itemtype"],
      );
    } catch (e) {
      return ItemTicket();
    }
  }

  Future<List<ItemTicket>> fetchItemTicketData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<ItemTicket>((json) => ItemTicket.fromMap(json)).toList();
  }

  getAllItemTicket() async {
    List<ItemTicket> futureItemTicket;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiRootItemTicket);
    futureItemTicket = await fetchItemTicketData(apiResp);

    return futureItemTicket;
  }
}
