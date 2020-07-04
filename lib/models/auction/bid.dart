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

  static BidIterator getBidIterator({
    @required String auctionId,
    @required int pageSize,
  }) {
    return BidIterator(auctionId: auctionId, size: pageSize);
  }

  /* ------------------------------------------------------------
    Get stream of bids of auction
  ------------------------------------------------------------ */

  static Stream<Bid> getBidsStream({
    @required String auctionId,
  }) {
    return ServerApi.instance().getBidsStream(
      auctionId: auctionId,
    );
  }
}

class BidIterator {
  final String auctionId;
  final int size;
  int _offset = 0;
  List<Bid> _currentPage;

  BidIterator({this.size, this.auctionId});

  List<Bid> get current {
    return _currentPage;
  }

  Future<bool> moveNext() async {
    _offset += size;

    _currentPage = await ServerApi.instance().getCurrentBids(
      auctionId: auctionId,
      offset: _offset,
      limit: size,
    );

    return _currentPage.isNotEmpty;
  }
}
