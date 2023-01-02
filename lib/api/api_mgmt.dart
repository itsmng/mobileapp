import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

///Class to manage api call
class ApiMgmt {
  String? apiBaseUrl;
  String? apiAuthToken;
  String? apiSessionToken;
  String? userToken;
  bool checkSSL = false;
  bool authStatus = false;
  final String headerType = "application/json;charset=UTF-8";

  ApiMgmt();

  dynamic get(String relativeUrl) async {
    final response = await http
        .get(Uri.parse(getAbsoluteUrl(relativeUrl)), headers: <String, String>{
      'App-token': apiAuthToken.toString(),
      'Session-token': apiSessionToken.toString(),
      HttpHeaders.contentTypeHeader: headerType,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      authStatus = true;
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      authStatus = false;
      throw Exception("Failed to get data from the endpoind $relativeUrl");
    }
  }

  // Method to init the connexion
  dynamic authentification(String relativeUrl) async {
    final response = await http
        .get(Uri.parse(getAbsoluteUrl(relativeUrl)), headers: <String, String>{
      'App-token': apiAuthToken.toString(),
      'Authorization': "${"user_token"} $userToken",
      HttpHeaders.contentTypeHeader: headerType,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      authStatus = true;

      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      authStatus = false;
      return {
        "Session-token": null,
      };
    }
  }

  // Metod to logged out
  void logoutFromItsmAPI(String relativeUrl) async {
    final response = await http
        .get(Uri.parse(getAbsoluteUrl(relativeUrl)), headers: <String, String>{
      'App-token': apiAuthToken.toString(),
      'Session-token': apiSessionToken.toString(),
      HttpHeaders.contentTypeHeader: headerType,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      authStatus = false;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to kill the session');
    }
  }

  // return the the url with API url + endpoind as parameter
  String getAbsoluteUrl(String endpoint) {
    final String uri = apiBaseUrl.toString() + endpoint;
    return uri;
  }

  // Set api session token
  void setApiSessionToken(String sessionToken) {
    apiSessionToken = sessionToken;
  }

  // set the url of the API
  void setApiBaseUrl(String apiBaseUrl) {
    this.apiBaseUrl = apiBaseUrl;
  }

  // Set the token of the API
  void setApiAuthToken(String apiAuthToken) {
    this.apiAuthToken = apiAuthToken;
  }

  // Set the token of the user
  void setUserToken(String userToken) {
    this.userToken = userToken;
  }

  // Set the the ssl check
  void setCheckSSL(bool checkSSL) {
    this.checkSSL = checkSSL;
  }
}
