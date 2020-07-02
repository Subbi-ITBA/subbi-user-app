import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:subbi/apis/remote_config_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/others/error_logger.dart';
import 'package:subbi/models/auction/bid.dart';

class ServerApi {
  static ServerApi _singleton = new ServerApi._internal();

  ServerApi._internal();

  factory ServerApi.instance() {
    host = host ?? RemoteConfigApi.instance().serverURL;

    client = client ?? HttpClient();
    port = port ?? RemoteConfigApi.instance().serverPort;

    return _singleton;
  }

  static String host;
  static int port;
  static HttpClient client;
  static int signUpStatusCode = 404;

  Cookie sessionCookie;

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                         ACCOUNT MANAGEMENT
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
    Performs a login and returns if user exists or should sign up
  ---------------------------------------------------------------------------- */

  Future<bool> signIn({
    @required String userToken,
  }) async {
    var req = await client.post(host, port, '/login');

    req.headers.add('Content-Type', 'application/json');
    req.write(jsonEncode({'idToken': userToken}));

    var res = await req.close();

    if (res.statusCode != 200 && res.statusCode != 404)
      ErrorLogger.log(context: "Loging in", error: res.reasonPhrase);

    sessionCookie =
        res.cookies.firstWhere((cookie) => cookie.name == 'session');

    return res.statusCode != signUpStatusCode;
  }

  /* ----------------------------------------------------------------------------
    Creates a new user, sends personal data to the server
  ---------------------------------------------------------------------------- */

  Future<void> signUp({
    @required String name,
    @required String surname,
    @required DocType docType,
    @required String docId,
    @required String phone,
    @required PhoneType phoneType,
    @required String country,
    @required String state,
    @required String city,
    @required String address,
    @required String addressNumber,
    @required String zip,
  }) async {
    var req = await client.post(host, port, '/register');
    req.cookies.add(sessionCookie);

    req.headers.add('Content-Type', 'application/json');
    req.write(jsonEncode({
      "name": name,
      "last_name": surname,
      "document_type": docType.toString().split('.')[1].toLowerCase(),
      "document": docId,
      "telephone_type": phoneType.toString().split('.')[1].toLowerCase(),
      "telephone": phone,
      "country": country,
      "province": state,
      "location": city,
      "zip": zip,
      "street": address,
      "street_number": addressNumber
    }));

    var res = await req.close();

    if (res.statusCode != 201)
      ErrorLogger.log(context: "Signing up", error: res.reasonPhrase);
  }

  /* ----------------------------------------------------------------------------
    Deletes a user account
  ---------------------------------------------------------------------------- */

  Future<void> deleteAccount({
    @required String uid,
  }) async {
    var req = await client.delete(host, port, '/user/' + uid);
    req.cookies.add(sessionCookie);

    var res = await req.close();

    if (res.statusCode != 200)
      ErrorLogger.log(context: "Deleting account", error: res.reasonPhrase);
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      PROFILE
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
    Creates a new user, sends personal data to the server
    //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<Map<String, dynamic>> getProfile({
    @required String uid,
  }) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Follow a profile
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<void> followProfile({
    @required String uid,
    @required String followUid,
    @required bool follow,
  }) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Rate a profile
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<void> rateProfile({
    @required String uid,
    @required String rateUid,
    @required int rating,
  }) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Get the ratings of a profile
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<List<Map<String, dynamic>>> getRatings({
    @required String ofUid,
  }) {
    throw UnimplementedError();
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      AUCTION
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
   Get the auctions of a profile
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<List<Map<String, dynamic>>> getProfileAuctions({
    @required String ofUid,
  }) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Get a specific set of auctions ()
  ---------------------------------------------------------------------------- */

  Future<List<Auction>> getAuctionsBySort({
    @required String category,
    @required int limit,
    @required int offset,
    @required String sort,
  }) async {
    var cat = category
        .toString()
        .substring(category.toString().indexOf(".") + 1)
        .toLowerCase();

    String path = category == null
        ? '/auction/list?sort=$sort&limit=$limit&offset=$offset'
        : '/auction/list?sort=$sort&limit=$limit&offset=$offset&category=$cat';

    var req = await client.get(host, port, path);
    var res = await req.close();

    if (res.statusCode != 200) {
      ErrorLogger.log(
          context: 'Getting $sort auctions', error: res.reasonPhrase);
    }

    await for (var contents in res.transform(Utf8Decoder())) {
      print(contents);
    }

    return null;
  }

  Future<void> postAuction({@required Map<String, dynamic> auctionJson}) {
    throw UnimplementedError();
  }

  Future<void> deleteAuction({@required String auctionId}) {
    throw UnimplementedError();
  }

  Future<List<Auction>> getParticipatingAuctions(
      {@required String uid, @required limit, @required offset}) async {
    var req = await client.get(host, port, '/auction/list/');
    var res = await req.close();
    if (res.statusCode != 200) {
      ErrorLogger.log(
          context: 'Getting user participating auctions',
          error: res.reasonPhrase);
    }
    await for (var contents in res.transform(Utf8Decoder())) {
      print(contents);
    }
    return null;
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      LOTS
  ------------------------------------------------------------------------------------------------------------------------------- */
  Future<void> postLot(
      {@required String title,
      @required String category,
      @required String description,
      @required double initialPrice,
      @required int quantity}) async {
    var req = await client.post(host, port, '/lot');
    req.cookies.add(sessionCookie);
    req.headers.add('Content-Type', 'application/json');

    req.write(jsonEncode({
      "name": title,
      "category": category,
      "description": description,
      "initial_price": initialPrice,
      "quantity": quantity
    }));
    var res = await req.close();

    if (res.statusCode != 201)
      ErrorLogger.log(context: "Send lot", error: res.reasonPhrase);
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      BIDS
  ------------------------------------------------------------------------------------------------------------------------------- */

  Future<List<Bid>> getCurrentBids({@required String auctionId}) {}

  Stream<Map<String, dynamic>> getBidsStream({@required String auctionId}) {
    throw UnimplementedError();
  }

  Future<void> postBid({@required Map<String, dynamic> bidJson}) {
    throw UnimplementedError();
  }
}

enum DocType { DNI, CI, PASSPORT }

enum PhoneType { MOBILE, LANDLINE }

enum Category { TECHNOLOGY }

enum AuctionSort { LATEST, POPULARITY, DEADLINE }
