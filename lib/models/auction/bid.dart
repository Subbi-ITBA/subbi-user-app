import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';

class Bid {
  String auctionId;

  double amount;
  String placerUid;
  DateTime date;

  Bid({
    @required this.auctionId,
    @required this.amount,
    @required this.placerUid,
    @required this.date,
  });

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 MANAGING BID
  ------------------------------------------------------------------------------------------------------------------------ */

  Future<void> place() {
    return ServerApi.instance().postBid(
      auctionId: auctionId,
      amount: amount,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING BIDS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get current bids of auction
  ------------------------------------------------------------ */

  static Future<List<Bid>> getCurrentBids({@required String auctionId}) async {
    return await ServerApi.instance().getCurrentBids(
      auctionId: auctionId,
    );
  }

  /* ------------------------------------------------------------
    Get stream of bids of auction
  ------------------------------------------------------------ */

  static Stream<Bid> getBidsStream({@required String auctionId}) {
    return ServerApi.instance().getBidsStream(
      auctionId: auctionId,
    );
  }
}
