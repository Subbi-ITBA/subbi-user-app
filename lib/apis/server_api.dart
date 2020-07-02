import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:subbi/apis/remote_config_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/others/error_logger.dart';
import 'package:subbi/models/auction/bid.dart';
import 'package:http/http.dart' as http;

class ServerApi {
  static ServerApi _singleton = new ServerApi._internal();

  ServerApi._internal();

  factory ServerApi.instance() {
    host = host ?? RemoteConfigApi.instance().serverURL;
    //client = client ?? HttpClient();
    return _singleton;
  }

  static String host;
  static int signUpStatusCode = 404;

  String sessionCookie;

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                         ACCOUNT MANAGEMENT
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
    Performs a login and returns if user exists or should sign up
  ---------------------------------------------------------------------------- */

  Future<bool> signIn({
    @required String userToken,
  }) async {
    var res = await http.post(
      host + '/login',
      headers: {
        'Content-Type': 'application/json',
      },
      body: {
        'idToken': userToken,
      },
    );

    if (res.statusCode != 200 && res.statusCode != 404)
      ErrorLogger.log(
        context: "Loging in",
        error: res.reasonPhrase,
      );

    sessionCookie = res.headers['Cookie'];

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
    var res = await http.post(
      host + '/register',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      },
      body: {
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
        "street_number": addressNumber,
      },
    );

    if (res.statusCode != 201)
      ErrorLogger.log(
        context: "Signing up",
        error: res.reasonPhrase,
      );
  }

  /* ----------------------------------------------------------------------------
    Deletes a user account
  ---------------------------------------------------------------------------- */

  Future<void> deleteAccount({
    @required String uid,
  }) async {
    var res = await http.delete(
      host + '/user/' + uid,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      },
    );

    if (res.statusCode != 200)
      ErrorLogger.log(
        context: "Deleting account",
        error: res.reasonPhrase,
      );
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
   Get a specific set of auctions (LATEST, POPULARITY, DEADLINE)
  ---------------------------------------------------------------------------- */

  Future<List<Map<String, dynamic>>> getAuctionsBySort({
    @required String category,
    @required int limit,
    @required int offset,
    @required AuctionSort sort,
  }) async {
    var sortString = sort
        .toString()
        .toLowerCase()
        .split('.')[1]; // Conversion from enum to string

    String path = category == null
        ? '/auction/list?sort=$sortString&limit=$limit&offset=$offset'
        : '/auction/list?sort=$sortString&limit=$limit&offset=$offset&category=$category';

    var res = await http.get(
      host + path,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      },
    );

    if (res.statusCode != 200) {
      ErrorLogger.log(
        context: 'Getting $sort auctions',
        error: res.reasonPhrase,
      );
    }

    return jsonDecode(res.body);
  }

  /* ----------------------------------------------------------------------------
   Post an auction
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<void> postAuction({@required Map<String, dynamic> auctionJson}) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Delete an auction
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<void> deleteAuction({@required String auctionId}) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Get the auctions on which a user is participating
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<List<Map<String, dynamic>>> getParticipatingAuctions({
    @required String uid,
    @required limit,
    @required offset,
  }) async {
    var res = await http.get(
      host + '/auction/list/',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      },
    );

    if (res.statusCode != 200) {
      ErrorLogger.log(
        context: 'Getting user participating auctions',
        error: res.reasonPhrase,
      );
    }

    return jsonDecode(res.body);
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      LOTS
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
   Post a new lot
  ---------------------------------------------------------------------------- */

  Future<void> postLot({
    @required String title,
    @required String category,
    @required String description,
    @required double initialPrice,
    @required int quantity,
  }) async {
    var res = await http.post(
      host + '/lot',
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie,
      },
      body: {
        "name": title,
        "category": category,
        "description": description,
        "initial_price": initialPrice,
        "quantity": quantity,
      },
    );

    if (res.statusCode != 201)
      ErrorLogger.log(
        context: "Send lot",
        error: res.reasonPhrase,
      );
  }

  /* -------------------------------------------------------------------------------------------------------------------------------
                                                      BIDS
  ------------------------------------------------------------------------------------------------------------------------------- */

  /* ----------------------------------------------------------------------------
   Get the current bids of an auction
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<List<Bid>> getCurrentBids({@required String auctionId}) {}

  /* ----------------------------------------------------------------------------
   Get a stream of bids of an auction
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Stream<Map<String, dynamic>> getBidsStream({@required String auctionId}) {
    throw UnimplementedError();
  }

  /* ----------------------------------------------------------------------------
   Post a new bid
   //TODO: Implement
  ---------------------------------------------------------------------------- */

  Future<void> postBid({@required Map<String, dynamic> bidJson}) {
    throw UnimplementedError();
  }
}

enum DocType { DNI, CI, PASSPORT }

enum PhoneType { MOBILE, LANDLINE }

enum AuctionSort { LATEST, POPULARITY, DEADLINE }
