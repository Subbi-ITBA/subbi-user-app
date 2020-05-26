import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/profile/profile.dart';

import 'bid.dart';

class Auction {

  String ownerUid;
  String title;
  String description;
  String category;
  String imageURL;
  DateTime deadLine;
  int quantity;
  double initialPrice;

  List<Bid> _bids;

  Auction({
    @required this.ownerUid,
    @required this.title,
    @required this.description,
    @required this.category,
    @required this.imageURL,
    @required this.deadLine,
    @required this.quantity,
    @required this.initialPrice
  });

  Bid getHighestBid() => this._bids.last;
  List<Bid> getBids() => this._bids;

  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

  /* ------------------------------------------------------------
    Fetches bids if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<Bid>> get bids async {
    if (_bids == null) ;
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
