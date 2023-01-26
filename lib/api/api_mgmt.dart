import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobileapp/models/tickets_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Class to manage api call
class ApiMgmt {
  String urlAPI = "";
  String appTokenAPI = "";
  String userTokenAPI = "";
  String? apiSessionToken;
  bool checkSSL = false;
  bool authStatus = false;
  final String headerType = "application/json;charset=UTF-8";

  ApiMgmt();

  dynamic get(String relativeUrl) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();

      final response = await http.get(
          Uri.parse(
              getAbsoluteUrl(prefs.getString('URL').toString(), relativeUrl)),
          headers: <String, String>{
            'App-token': prefs.getString('App-token') ?? 0.toString(),
            'Session-token': prefs.getString('Session-token') ?? 0.toString(),
            HttpHeaders.contentTypeHeader: headerType,
          });

      if (response.statusCode == 200 ||
          response.statusCode == 206 ||
          response.statusCode == 201) {
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
    } catch (_) {
      return null;
    }
  }

  dynamic put(String relativeUrl, int id, Map dataToJson) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();

      final jsonText = jsonEncode({'input': dataToJson},
          toEncodable: (Object? value) => value is Tickets
              ? Tickets.toJson(value)
              : throw UnsupportedError('Cannot convert to JSON: $value'));
      final response = await http
          .put(
              Uri.parse(getAbsoluteUrlWithID(
                  prefs.getString('URL').toString(), relativeUrl, id)),
              headers: <String, String>{
                'App-token': prefs.getString('App-token') ?? 0.toString(),
                'Session-token':
                    prefs.getString('Session-token') ?? 0.toString(),
                HttpHeaders.contentTypeHeader: headerType,
              },
              body: jsonText)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200 ||
          response.statusCode == 206 ||
          response.statusCode == 201) {
        // If the server did return a 200 OK response,
        return {
          "update": "true",
        };
      } else {
        // If the server did not return a 200 OK response,
        return {
          "update": "false",
        };
      }
    } on SocketException catch (_) {
      return {
        "update": "errorUpdate",
      };
    } on TimeoutException catch (_) {
      return {
        "update": "errorUpdate",
      };
    } catch (_) {
      return {
        "update": "errorUpdate",
      };
    }
  }

  dynamic delete(String relativeUrl, int id) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();

      final response = await http.delete(
        Uri.parse(getAbsoluteUrlWithID(
            prefs.getString('URL').toString(), relativeUrl, id)),
        headers: <String, String>{
          'App-token': prefs.getString('App-token') ?? 0.toString(),
          'Session-token': prefs.getString('Session-token') ?? 0.toString(),
          HttpHeaders.contentTypeHeader: headerType,
        },
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200 ||
          response.statusCode == 206 ||
          response.statusCode == 201) {
        // If the server did return a 200 OK response,
        return {
          "delete": "true",
        };
      } else {
        // If the server did not return a 200 OK response,
        return {
          "delete": "false",
        };
      }
    } on SocketException catch (_) {
      return {
        "delete": "errorDelete",
      };
    } on TimeoutException catch (_) {
      return {
        "delete": "errorDelete",
      };
    } catch (_) {
      return {
        "delete": "errorDelete",
      };
    }
  }

  dynamic post(String relativeUrl, Map dataToJson) async {
    try {
      // obtain shared preferences
      final prefs = await SharedPreferences.getInstance();

      final jsonText = jsonEncode({'input': dataToJson},
          toEncodable: (Object? value) => value is Tickets
              ? Tickets.toJson(value)
              : throw UnsupportedError('Cannot convert to JSON: $value'));
      final response = await http
          .post(
              Uri.parse(getAbsoluteUrl(
                  prefs.getString('URL').toString(), relativeUrl)),
              headers: <String, String>{
                'App-token': prefs.getString('App-token') ?? 0.toString(),
                'Session-token':
                    prefs.getString('Session-token') ?? 0.toString(),
                HttpHeaders.contentTypeHeader: headerType,
              },
              body: jsonText)
          .timeout(const Duration(seconds: 120));

      if (response.statusCode == 200 ||
          response.statusCode == 206 ||
          response.statusCode == 201) {
        // If the server did return a 200 OK response,
        var getID = await jsonDecode(response.body);
        return {
          "add": "true",
          "id": getID["id"],
        };
      } else {
        // If the server did not return a 200 OK response,
        return {
          "add": "false",
        };
      }
    } on SocketException catch (_) {
      return {
        "add": "errorAdd",
      };
    } on TimeoutException catch (_) {
      return {
        "add": "errorAdd",
      };
    } catch (_) {
      return {
        "add": "errorAdd",
      };
    }
  }

  // Method to init the connexion
  dynamic authentification(String relativeUrl, String apiAuthToken,
      String userToken, String apiBaseUrl) async {
    try {
      final response = await http.get(
          Uri.parse(getAbsoluteUrl(apiBaseUrl, relativeUrl)),
          headers: <String, String>{
            'App-token': apiAuthToken,
            'Authorization': "${"user_token"} $userToken",
            HttpHeaders.contentTypeHeader: headerType,
          }).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        authStatus = true;

        // obtain shared preferences
        final prefs = await SharedPreferences.getInstance();
        urlAPI = prefs.getString('URL').toString();
        appTokenAPI = prefs.getString('App-token').toString();
        userTokenAPI = prefs.getString('User-token').toString();

        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return {
          "Session_token": "errorURL",
        };
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        authStatus = false;
        String? errorMessage;
        var tab = response.body.split(",");
        errorMessage = tab[0].substring(2, tab[0].length - 1);
        return {
          "Session_token": errorMessage,
        };
      }
    } on SocketException catch (_) {
      return {
        "Session_token": "errorURL",
      };
    } on TimeoutException catch (_) {
      return {
        "Session_token": "errorURL",
      };
    } catch (_) {
      return {
        "Session_token": "errorURL",
      };
    }
  }

  // Metod to logged out
  void logoutFromItsmAPI(String relativeUrl) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse(
            getAbsoluteUrl(prefs.getString('URL').toString(), relativeUrl)),
        headers: <String, String>{
          'App-token': prefs.getString('App-token') ?? 0.toString(),
          'Session-token': prefs.getString('Session-token') ?? 0.toString(),
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
  String getAbsoluteUrl(String apiBaseUrl, String endpoint) {
    final String uri = apiBaseUrl + endpoint;
    return uri;
  }

  // return the the url with API url + endpoind as parameter
  String getAbsoluteUrlWithID(String apiBaseUrl, String endpoint, int id) {
    final String uri = apiBaseUrl + endpoint + id.toString();
    return uri;
  }

  // Save data on the disk
  Future<void> saveStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    // set value
    await prefs.setString(key, value);
  }

  // Save data on the disk
  Future<void> saveBoolData(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    // set value
    await prefs.setBool(key, value);
  }

  // Set api session token
  void setApiSessionToken(String sessionToken) {
    apiSessionToken = sessionToken;
  }

  // Set the the ssl check
  void setCheckSSL(bool checkSSL) {
    this.checkSSL = checkSSL;
  }
}
