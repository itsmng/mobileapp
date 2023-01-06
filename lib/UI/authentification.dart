import 'package:flutter/material.dart';
import 'package:mobileapp/UI/home_page.dart';
import 'package:mobileapp/api/model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:regexed_validator/regexed_validator.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  static final _initSession = InitSession();
  late Future<InitSession> futureSession;

  String _url = _initSession.apiMgmt.apiBaseUrl;
  String _apiToken = _initSession.apiMgmt.apiAuthToken;
  String _userToken = _initSession.apiMgmt.userToken;
  bool _checkSSL = _initSession.apiMgmt.checkSSL;
  late String sessionTokenValue;
  static const String initSession = "initSession";
  static const String sessionTokenField = "Session_token";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiTokenController = TextEditingController();
  final TextEditingController _userTokenController = TextEditingController();

  @override
  void initState() {
    _urlController.text = _url;
    _apiTokenController.text = _apiToken;
    _userTokenController.text = _userToken;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 12, 42),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text("Authentification API ITSM-NG"),
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
                  child: const Text(
                    'Valider',
                    style: TextStyle(
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
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.link, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: "URL de l'API ITSM",
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.url,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return 'API URL is Required';
        }
        if (!validator.url(value.toString())) {
          return 'Enter a valid URL';
        }
        return null;
      },
      onSaved: (String? value) {
        _url = value.toString();
        _initSession.apiMgmt.setApiBaseUrl(_url.toString());
      },
      onChanged: (String value) {
        _url = value;
      },
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildApiToken() {
    return TextFormField(
      controller: _apiTokenController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.login, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: 'Token API de connexion',
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return 'API token is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _apiToken = value.toString();
        _initSession.apiMgmt.setApiAuthToken(_apiToken);
      },
      onChanged: (String value) {
        _apiToken = value;
      },
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildUserToken() {
    return TextFormField(
      controller: _userTokenController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.white),
        focusColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          //<-- SEE HERE
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: 'Token user de connexion',
        labelStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return 'API token is Required';
        }
        return null;
      },
      onSaved: (String? value) {
        _userToken = value.toString();
        _initSession.apiMgmt.setUserToken(_userToken);
      },
      onChanged: (String value) {
        _userToken = value;
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
        const Text(
          'Vérification du certificat SSL ',
          style: TextStyle(fontSize: 17.0, color: Colors.white),
        ),
      ],
    );
  }

  void controlAuthentification() async {
    _formKey.currentState!.save();
    Future<dynamic> apiResponse =
        _initSession.apiMgmt.authentification(initSession);

    final apiResponseValue =
        await apiResponse.then((val) => val[sessionTokenField]);
    if (apiResponseValue == "ERROR_WRONG_APP_TOKEN_PARAMETER" &&
        apiResponseValue != null) {
      //alert error connexion
      Alert(
        context: context,
        desc: "le paramètre app_token semble incorrect",
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
      //alert error connexion
      Alert(
        context: context,
        desc: "le paramètre user_token semble incorrect",
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
      //alert error connexion
      Alert(
        context: context,
        desc: "L'url semble incorrect",
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
