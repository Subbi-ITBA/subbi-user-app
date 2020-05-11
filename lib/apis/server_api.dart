import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:subbi/apis/remote_config_api.dart';
import 'package:subbi/others/error_logger.dart';

class ServerApi{

  static ServerApi _singleton = new ServerApi._internal();

  ServerApi._internal();

  factory ServerApi.instance({bool testMode=false, HttpClient httpClient}){
    _singleton.host = testMode ? 'test' : RemoteConfigApi.instance().serverURL;
    _singleton.client = httpClient ?? HttpClient();
    _singleton.port = testMode ? 80 : RemoteConfigApi.instance().serverPort;
    return _singleton;
  }

  String host;
  int port;
  int signUpStatusCode = 404;
  HttpClient client;

  Cookie sessionCookie;


  /* ----------------------------------------------------------------------------
    POST /login
    Body: {'idToken': token}
    Returns: Session cookie
    Performs a login and returns if user exists or should sign up
  ---------------------------------------------------------------------------- */

  Future<bool> signIn({@required String userToken}) async {

    var req = await client.postUrl(Uri.http(host, '/login'));

    req.write(jsonEncode({'idToken': userToken}));

    var res = await req.close();

    if(res.statusCode!=200 && res.statusCode!=404)
      ErrorLogger.log(context: "Loging in", error: res.reasonPhrase);

    sessionCookie = res.cookies.firstWhere((cookie) => cookie.name=='session');

    return res.statusCode != signUpStatusCode;

  }


  /* ----------------------------------------------------------------------------
    POST /register
    Body: {
      "name": name, "last_name": surname, "document_type": docType, "document": docId,
      "telephone_type": phoneType, "telephone": phone,
      "country": country, "province": state, "location": city, "zip": zip,
      "street": address, "street_number": addressNumber
    }
    Cookie: Session cookie
    Sends personal data to the server
  ---------------------------------------------------------------------------- */

  Future<void> signUp({@required String name, @required String surname, @required DocType docType, @required String docId,
    @required String phone, @required PhoneType phoneType, @required String country, @required String state, @required String city,
    @required String address, @required String addressNumber, @required String zip,}) async {

    var req = await client.post(host, port, '/register');
    req.cookies.add(sessionCookie);

    req.write(jsonEncode(
      {
        "name": name,
        "last_name": surname,
        "document_type": docType.toString().split('.')[1],
        "document": docId,
        "telephone_type": phoneType.toString().split('.')[1],
        "telephone": phone,
        "country": country,
        "province": state,
        "location": city,
        "zip": zip,
        "street": address,
        "street_number": addressNumber
      }
    ));


    var res = await req.close();

    if(res.statusCode!=200)
      ErrorLogger.log(context: "Signing up", error: res.reasonPhrase);

  }


}

enum DocType{DNI, CI, PASSPORT}

enum PhoneType{MOBILE, LANDLINE}