import 'dart:convert';

import 'package:mobileapp/api/api_mgmt.dart';
import 'package:mobileapp/models/special_status.dart';

List<Tickets> postFromJson(String str) =>
    List<Tickets>.from(json.decode(str).map((x) => Tickets.fromMap(x)));

class Tickets {
  String? date;
  int? statusID;
  String? statusValue;
  String? timeToResolve;
  String? title;
  String? category;
  String? location;
  String? lastUpdate;
  String? entity;
  String? priority;
  int? id;

  final apiMgmt = ApiMgmt();

  Tickets({
    this.date,
    this.statusID,
    this.timeToResolve,
    this.title,
    this.category,
    this.location,
    this.lastUpdate,
    this.entity,
    this.priority,
    this.id,
    this.statusValue,
  });

  factory Tickets.fromMap(Map<String, dynamic> json) {
    Map<int, String> listPriority = {
      1: "Very low",
      2: "Low",
      3: "Medium",
      4: "High",
      5: "Very high",
      6: "Major"
    };

    if (json["itilcategories_id"] == 0) {
      json["itilcategories_id"] = "";
    }
    if (json["locations_id"] == 0) {
      json["locations_id"] = "";
    }

    if (listPriority.containsKey(json["priority"])) {
      json["priority"] = listPriority[json["priority"]];
    }

    return Tickets(
      date: json["date"],
      statusID: json["status"],
      timeToResolve: json["time_to_resolve"],
      title: json["name"],
      category: json["itilcategories_id"],
      location: json["locations_id"],
      lastUpdate: json["date_mod"],
      entity: json["entities_id"],
      priority: json["priority"].toString(),
      id: json["id"],
      statusValue: json["status"].toString(),
    );
  }

  static Map<String, dynamic> toJson(Tickets value) =>
      {'name': value.title, 'priority': value.priority};

  // Method to get all special status and return a list of them
  static Future<Map<int, String>> getSpecialStatusValues() async {
    final specialStatusObject = SpecialStatus();
    List<SpecialStatus> specialStatuses =
        await specialStatusObject.getAllSpecialStatus();
    Map<int, String> list = {};
    for (var e in specialStatuses) {
      list[e.id!] = e.name.toString();
    }
    return list;
  }

  // A function that converts a response body into a List<Photo>.
  Future<List<Tickets>> fetchTicketsData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();
    var listTickets =
        parsed.map<Tickets>((json) => Tickets.fromMap(json)).toList();

    // Retrieve the list of the special status
    Map<int, String> listStatus = await getSpecialStatusValues();

    // Replace the special status id by there matching name
    for (Tickets ele in listTickets) {
      if (listStatus.containsKey(ele.statusID)) {
        ele.statusValue = listStatus[ele.statusID];
      }
    }

    return listTickets;
  }

  // Method to return Tickets's attributes by selected
  getAttribute(String name) {
    switch (name) {
      case "Date":
        return date;
      case "Status":
        return statusValue;
      case "Time to resolve":
        return timeToResolve;
      case "Title":
        return title;
      case "Category":
        return category;
      case "Location":
        return location;
      case "Last update":
        return lastUpdate;
      case "Entity":
        return entity;
      case "Priority":
        return priority;
      case "ID":
        return id;

      // return by defaul the date if no choise
      default:
        return date;
    }
  }
}
