import 'dart:async';

import 'package:mobileapp/api/api_mgmt.dart';

/// Model for InitSession
class InitSession {
  String? sessionToken;
  static const String initSession = "initSession";
  static const String killSession = "killSession";
  final apiMgmt = ApiMgmt();

  /// Constructor
  InitSession({
    this.sessionToken,
  });

  /// Get data from JSON format
  factory InitSession.fromJson(Map<String, dynamic> json) {
    return InitSession(
      sessionToken: json['session_token'],
    );
  }


  /// Retrieve from API response
  Future<InitSession> fetchInitSessionData(Future<dynamic> data) async {
    return InitSession.fromJson(await data);
  }
}
