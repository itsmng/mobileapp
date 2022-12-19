import 'dart:async';

import 'package:mobileapp/api/api_mgmt.dart';

/// Class for models
class InitSession {
  String? sessionToken;
  static const String initSession = "initSession";
  static const String killSession = "killSession";
  final apiMgmt = ApiMgmt();

  InitSession({
    this.sessionToken,
  });

  factory InitSession.fromJson(Map<String, dynamic> json) {
    return InitSession(
      sessionToken: json['session_token'],
    );
  }

  Future<InitSession> fetchInitSessionData(Future<dynamic> data) async {
    return InitSession.fromJson(await data);
  }
}
