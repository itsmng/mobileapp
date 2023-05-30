import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class Task {
  int? id;
  int? ticketID;
  String? date;
  int? userID;
  int? isPrivate;
  String? content;
  int? duration;
  String? fullDuration;
  int? state;
  String? stateVlaue;

  final apiMgmt = ApiMgmt();

  Task({
    this.id,
    this.ticketID,
    this.date,
    this.userID,
    this.isPrivate,
    this.content,
    this.duration,
    this.state,
    this.stateVlaue,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    // Remove &lt;p&gt; and &lt;/p&gt; caracters adding by the API
    json["content"] =
        json["content"].toString().replaceAll(RegExp(r'&lt;p&gt;'), "");
    json["content"] =
        json["content"].toString().replaceAll(RegExp(r'&lt;/p&gt;'), "\n");

    Map<int, String> listToDo = {
      0: "Information",
      1: "To do",
      2: "Done",
    };
    String? stateVal;
    if (listToDo.containsKey(json["state"])) {
      stateVal = listToDo[json["state"]];
    }

    return Task(
      id: json["id"],
      ticketID: json["tickets_id"],
      date: json["date"],
      userID: json["users_id"],
      isPrivate: json["is_private"],
      content: json["content"],
      duration: json["actiontime"],
      state: json["state"],
      stateVlaue: stateVal,
    );
  }

  Future<List<Task>> fetchTaskData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();
    var listTasks = parsed.map<Task>((json) => Task.fromMap(json)).toList();

    for (Task task in listTasks) {
      int h = task.duration! ~/ 3600;
      int m = (task.duration! - h * 3600) ~/ 60;
      if (task.duration != 0) {
        task.fullDuration = "$h h $m m";
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
