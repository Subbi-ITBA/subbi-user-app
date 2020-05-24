import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/profile/profile.dart';

import 'bid.dart';

class Auction{

  String title;
  String imagesURL;
  DateTime deadLine;
  String ownerUid;

  List<Bid> _bids;


  Auction({@required owner, @required this.title, @required this.imagesURL, @required this.deadLine, @required this.ownerUid});

  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();


  /* ------------------------------------------------------------
    Fetches bids if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<Bid>> get bids async{

    if(_bids==null);
      // Fetch bids from server

    return _bids;

  }


  Stream<Bid> subscribeToBids() => throw UnimplementedError();


  Future<Profile> get owner => throw UnimplementedError();


  
  static Future<List<Auction>> getAuctions(String ofUid) async{

    var jsons = await ServerApi.instance().getAuctions(ofUid: ofUid);

    return jsons.map((json) => fromJson(json));

  }


  static Auction fromJson(Map<String, dynamic> json){

  }


}