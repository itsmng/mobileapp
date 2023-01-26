import 'package:flutter/material.dart';
import 'package:mobileapp/UI/home_page.dart';
import 'package:mobileapp/api/model.dart';
import 'package:mobileapp/translations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  static final _initSession = InitSession();
  late Future<InitSession> futureSession;

  bool _checkSSL = _initSession.apiMgmt.checkSSL;
  late String sessionTokenValue;
  static const String initSession = "initSession";
  static const String sessionTokenField = "Session_token";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  late final TextEditingController _userTokenController =
      TextEditingController();

  @override
  void initState() {
    _urlController.text = _initSession.apiMgmt.urlAPI;
    _apiTokenController.text = _initSession.apiMgmt.appTokenAPI;
    _userTokenController.text = _initSession.apiMgmt.userTokenAPI;
    setParameters();
    return super.initState();
  }

  setParameters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("URL") != null &&
        prefs.getString("App-token") != null &&
        prefs.getString("User-token") != null) {
      setState(() {
        _urlController.text = prefs.getString("URL").toString();
        _apiTokenController.text = prefs.getString("App-token").toString();
        _userTokenController.text = prefs.getString("User-token").toString();
      });
    } else {
      _urlController.text = "";
      _apiTokenController.text = "";
      _userTokenController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 12, 42),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(Translations.of(context)!.text('auth_title')),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 2, left: 24, top: 10, right: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/login_logo_itsm.png', width: 150),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: _buildURL(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: _buildApiToken(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: _buildUserToken(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: _buildCheckSSL(),
                ),
                const SizedBox(
                  height: 30,
                ),

                // ElevatedButton
                ElevatedButton(
                  //MaterialButton
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 245, 183, 177), // background
                  ),
                  child: Text(
                    Translations.of(context)!.text('button_send'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 143, 90, 10),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      controlAuthentification();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildURL() {
    return TextFormField(
      controller: _urlController,
      // ignore: prefer_const_constructors
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.link, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: Translations.of(context)!.text('auth_url'),
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.url,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return Translations.of(context)!.text('auth_url_required');
        }
        if (!validator.url(value.toString())) {
          return Translations.of(context)!.text('auth_url_no_valid');
        }
        return null;
      },

      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildApiToken() {
    return TextFormField(
      controller: _apiTokenController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.login, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: const UnderlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: Translations.of(context)!.text('auth_api_token'),
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return Translations.of(context)!.text('auth_api_token_required');
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildUserToken() {
    return TextFormField(
      controller: _userTokenController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: const UnderlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: Translations.of(context)!.text('auth_user_token'),
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return Translations.of(context)!.text('auth_user_token_required');
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildCheckSSL() {
    return Row(
      children: <Widget>[
        Checkbox(
          fillColor: MaterialStateProperty.all(Colors.white),
          checkColor: Colors.blueAccent,
          activeColor: Colors.blueAccent,
          value: _checkSSL,
          onChanged: (bool? value) {
            setState(() {
              _checkSSL = value!;
              _initSession.apiMgmt.setCheckSSL(_checkSSL);
            });
          },
        ),
        Text(
          Translations.of(context)!.text('auth_isValidSSL'),
          style: const TextStyle(fontSize: 17.0, color: Colors.white),
        ),
      ],
    );
  }

  void controlAuthentification() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Translations.of(context)!.text('message_loading')),
      duration: const Duration(seconds: 1),
    ));
    _formKey.currentState!.save();
    Future<dynamic> apiResponse = _initSession.apiMgmt.authentification(
        initSession,
        _apiTokenController.text,
        _userTokenController.text,
        _urlController.text);

    final apiResponseValue =
        await apiResponse.then((val) => val[sessionTokenField]);

    if (apiResponseValue == "ERROR_WRONG_APP_TOKEN_PARAMETER" &&
        apiResponseValue != null) {
      if (!mounted) return;
      //alert error connexion
      Alert(
        context: context,
        desc: Translations.of(context)!.text('message_bad_api_token'),
        style: const AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            color: const Color.fromARGB(255, 245, 183, 177),
            onPressed: () => Navigator.pop(context),
            width: 90,
            child: const Text(
              'Valider',
              style: TextStyle(
                  color: Color.fromARGB(255, 143, 90, 10),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ).show();
    } else if (apiResponseValue == "ERROR_GLPI_LOGIN_USER_TOKEN" &&
        apiResponseValue != null) {
      if (!mounted) return;
      //alert error connexion
      Alert(
        context: context,
        desc: Translations.of(context)!.text('message_bad_user_token'),
        style: const AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            color: const Color.fromARGB(255, 245, 183, 177),
            onPressed: () => Navigator.pop(context),
            width: 90,
            child: const Text(
              'Valider',
              style: TextStyle(
                  color: Color.fromARGB(255, 143, 90, 10),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ).show();
    } else if (apiResponseValue == "errorURL" && apiResponseValue != null) {
      if (!mounted) return;
      //alert error connexion
      Alert(
        context: context,
        desc: Translations.of(context)!.text('message_bad_url'),
        style: const AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            color: const Color.fromARGB(255, 245, 183, 177),
            onPressed: () => Navigator.pop(context),
            width: 90,
            child: const Text(
              'Valider',
              style: TextStyle(
                  color: Color.fromARGB(255, 143, 90, 10),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ).show();
    } else {
      futureSession = _initSession.fetchInitSessionData(apiResponse);
      futureSession.then((InitSession data) {
        _initSession.apiMgmt
            .saveStringData("Session-token", data.sessionToken.toString());
        _initSession.apiMgmt
            .saveStringData("App-token", _apiTokenController.text);
        _initSession.apiMgmt
            .saveStringData("User-token", _userTokenController.text);
        _initSession.apiMgmt.saveStringData("URL", _urlController.text);
        _initSession.apiMgmt.saveBoolData("SSL", _checkSSL);
        _initSession.apiMgmt
            .saveBoolData("Auth-status", _initSession.apiMgmt.authStatus);

        _initSession.apiMgmt.setApiSessionToken(data.sessionToken.toString());
        if (_initSession.apiMgmt.apiSessionToken != null) {
          if (!mounted) return;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        }
      });
    }
  }
}
