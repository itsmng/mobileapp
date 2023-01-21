import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class ITILfollowup {
  int? id;
  String? itemtype;
  String? itemsID;
  String? date;
  String? userID;
  int? isPrivate;
  String? content;

  final apiMgmt = ApiMgmt();

  ITILfollowup({
    this.id,
    this.itemtype,
    this.itemsID,
    this.date,
    this.userID,
    this.isPrivate,
    this.content,
  });

  factory ITILfollowup.fromMap(Map<String, dynamic> json) {
    return ITILfollowup(
      id: json["id"],
      itemtype: json["itemtype"],
      itemsID: json["items_id"],
      date: json["date"],
      userID: json["users_id"],
      isPrivate: json["is_private"],
      content: json["content"],
    );
  }

  Future<List<ITILfollowup>> fetchITILfollowupData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed
        .map<ITILfollowup>((json) => ITILfollowup.fromMap(json))
        .toList();
  }

  getAllITILfollowup(int itemID) async {
    List<ITILfollowup> futureITILfollowup;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetTicketFollowup + itemID.toString());
    futureITILfollowup = await fetchITILfollowupData(apiResp);

    return futureITILfollowup;
  }
}
