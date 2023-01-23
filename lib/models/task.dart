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
  String? fullDuration;

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
    var listTasks = parsed.map<Task>((json) => Task.fromMap(json)).toList();

    for (Task task in listTasks) {
      int h = task.duration! ~/ 3600;
      int m = (task.duration! - h * 3600) ~/ 60;
      if (task.duration != 0) {
        task.fullDuration = "$h hours $m minutes";
      } else {
        task.fullDuration = "";
      }
    }
    return listTasks;
  }

  getAllTask(int itemID) async {
    List<Task> futureTask;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetTicketTask + itemID.toString());
    futureTask = await fetchTaskData(apiResp);

    return futureTask;
  }
}
