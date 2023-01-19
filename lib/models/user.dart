import 'dart:convert';

import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/api_mgmt.dart';

class User {
  int? id;
  String? name;

  final apiMgmt = ApiMgmt();

  User({
    this.id,
    this.name,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
    );
  }

  Future<List<User>> fetchUsersData(dynamic data) async {
    final parsed = json.decode(await data).cast<Map<String, dynamic>>();

    return parsed.map<User>((json) => User.fromMap(json)).toList();
  }

  getAllUsers() async {
    List<User> futureItilUsers;
    dynamic apiResp;

    apiResp = apiMgmt.get(ApiEndpoint.apiGetAllUsers);
    futureItilUsers = await fetchUsersData(apiResp);

    return futureItilUsers;
  }
}
