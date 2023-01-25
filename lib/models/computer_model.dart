import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/api/api_mgmt.dart';
import 'package:mobileapp/translations.dart';

List<Computer> postFromJson(String str) =>
    List<Computer>.from(json.decode(str).map((x) => Computer.fromMap(x)));

class Computer {
  String? statusID;
  int? id;
  String? entity;
  String? name;
  String? serial;
  String? otherSerial;
  String? userIdTech;
  String? source;
  String? location;
  String? userID;
  String? date;
  String? lastUpdate;
  String? comment;
  String? statusValue;

  final apiMgmt = ApiMgmt();

  Computer({
    this.statusID,
    this.id,
    this.entity,
    this.name,
    this.serial,
    this.otherSerial,
    this.userIdTech,
    this.source,
    this.location,
    this.userID,
    this.date,
    this.lastUpdate,
    this.comment,
    this.statusValue,
  });

  factory Computer.fromMap(Map<String, dynamic> json) {
    if (json["users_id_tech"] == 0) {
      json["users_id_tech"] = "";
    }
    if (json["locations_id"] == 0) {
      json["locations_id"] = "";
    }
    if (json["autoupdatesystems_id"] == 0) {
      json["autoupdatesystems_id"] = "";
    }
    if (json["users_id"] == 0) {
      json["users_id"] = "";
    }
    if (json["states_id"] == 0) {
      json["states_id"] = "";
    }

    return Computer(
      statusID: json["states_id"].toString(),
      id: json["id"],
      entity: json["entities_id"],
      name: json["name"],
      serial: json["serial"],
      otherSerial: json["otherserial"],
      userIdTech: json["users_id_tech"],
      source: json["autoupdatesystems_id"],
      location: json["locations_id"],
      userID: json["users_id"],
      date: json["date_creation"],
      lastUpdate: json["date_mod"],
      comment: json["comment"],
      statusValue: json["states_id"],
    );
  }

  Future<List<Computer>> fetchComputerData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    var listComputers =
        parsed.map<Computer>((json) => Computer.fromMap(json)).toList();

    return listComputers;
  }

  // Method to return Tickets's attributes by selected
  getAttribute(String title, BuildContext context) {
    if (title == Translations.of(context)!.text('name')) {
      return name;
    } else if (title == Translations.of(context)!.text('serial')) {
      return serial;
    } else if (title == Translations.of(context)!.text('open_date')) {
      return date;
    } else if (title == Translations.of(context)!.text('inventory')) {
      return otherSerial;
    } else if (title == Translations.of(context)!.text('location')) {
      return location;
    } else if (title == Translations.of(context)!.text('entity')) {
      return entity;
    } else if (title == Translations.of(context)!.text('user')) {
      return userID;
    } else if (title == Translations.of(context)!.text('last_update')) {
      return lastUpdate;
    } else if (title == Translations.of(context)!.text('technician')) {
      return userIdTech;
    } else if (title == "ID") {
      return id;
    } else if (title == Translations.of(context)!.text('status')) {
      return statusValue;
    } else if (title == Translations.of(context)!.text('source')) {
      return source;
    }
  }
}
