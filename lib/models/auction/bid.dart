import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/profile/profile.dart';

class Bid {
  String auctionId;
  String bidId;

  double amount;
  String placerUid;
  DateTime date;

  Bid(
      {@required this.auctionId,
      @required this.bidId,
      @required this.amount,
      @required this.placerUid,
      @required this.date});

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 MANAGING BID
  ------------------------------------------------------------------------------------------------------------------------ */

  Future<void> place() => ServerApi.instance().postBid(bidJson: _toJson());

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING BIDS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get current bids of auction
  ------------------------------------------------------------ */

  static Future<List<Bid>> getCurrentBids({@required String auctionId}) async {
    //var jsons = await ServerApi.instance().getCurrentBids(auctionId: auctionId);

    //return jsons.map((json) => _fromJson(json));    // TODO: Unmock this
    return [
      Bid(
          amount: 20,
          date: DateTime.now(),
          placerUid: null,
          auctionId: null,
          bidId: null)
    ];
  }

  /* ------------------------------------------------------------
    Get stream of bids of auction
  ------------------------------------------------------------ */

  static Stream<Bid> getBidsStream({@required String auctionId}) {
    var jsons = ServerApi.instance().getBidsStream(auctionId: auctionId);

    return jsons.map((json) => _fromJson(json));
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                  SERIALIZATION
  ------------------------------------------------------------------------------------------------------------------------ */

  static Bid _fromJson(Map<String, dynamic> json) => throw UnimplementedError();

  Map<String, dynamic> _toJson() => throw UnimplementedError();
}
