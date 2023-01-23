import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class Task {
  int? id;
  String? ticketID;
  String? date;
  String? userID;
  int? isPrivate;
  String? content;
  int? duration;

  final apiMgmt = ApiMgmt();

  Task({
    this.id,
    this.ticketID,
    this.date,
    this.userID,
    this.isPrivate,
    this.content,
    this.duration,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      ticketID: json["tickets_id"],
      date: json["date"],
      userID: json["users_id"],
      isPrivate: json["is_private"],
      content: json["content"],
      duration: json["actiontime"],
    );
  }

  Future<List<Task>> fetchTaskData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<Task>((json) => Task.fromMap(json)).toList();
  }

  getAllTask(int itemID) async {
    List<Task> futureTask;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetTicketTask + itemID.toString());
    futureTask = await fetchTaskData(apiResp);

    return futureTask;
  }
}
