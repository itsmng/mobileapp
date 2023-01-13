import 'dart:convert';

import 'package:mobileapp/api/api_mgmt.dart';

List<Tickets> postFromJson(String str) =>
    List<Tickets>.from(json.decode(str).map((x) => Tickets.fromMap(x)));

class Tickets {
  String? date;
  int? status;
  String? timeToResolve;
  String? title;
  String? category;
  String? location;

  final apiMgmt = ApiMgmt();

  Tickets({
    this.date,
    this.status,
    this.timeToResolve,
    this.title,
    this.category,
    this.location,
  });

  factory Tickets.fromMap(Map<String, dynamic> json) {
    if (json["itilcategories_id"] == 0) {
      json["itilcategories_id"] = "";
    }
    if (json["locations_id"] == 0) {
      json["locations_id"] = "";
    }
    return Tickets(
      date: json["date"],
      status: json["status"],
      timeToResolve: json["time_to_resolve"],
      title: json["name"],
      category: json["itilcategories_id"],
      location: json["locations_id"],
    );
  }

  Future<List<Tickets>> fetchTicketsData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<Tickets>((json) => Tickets.fromMap(json)).toList();
  }

  // Method to return Tickets's attributes by selected name 
  getAttribute(String name) {
    switch (name) {
      case "Date":
        return date;
      case "Status":
        return status;
      case "Time to resolve":
        return timeToResolve;
      case "Title":
        return title;
      case "Category":
        return category;
      case "Location":
        return location;

      // return by defaul the date if no choise
      default:
        return date;
    }
  }
}
