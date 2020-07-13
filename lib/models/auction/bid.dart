import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:subbi/apis/server_api.dart';

class Bid {
  int auctionId;

  double amount;
  String placerUid;
  DateTime date;

  Bid({
    @required this.auctionId,
    @required this.amount,
    @required this.placerUid,
    @required this.date,
  });

  @override
  String toString() {
    return "Bid{auc_id:$auctionId,amount:$amount,placerUid:$placerUid,date:$date}\n";
  }
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
    @required int auctionId,
    @required int pageSize,
  }) {
    return BidIterator(auctionId: auctionId, size: pageSize);
  }

  /* ------------------------------------------------------------
    Get stream of bids of auction
  ------------------------------------------------------------ */

  static Socket getBidsSocket({
    @required int auctionId,
  }) {
    return ServerApi.instance().getBidsSocket(
      auctionId: auctionId,
    );
  }
}

class BidIterator {
  final int auctionId;
  final int size;
  int _offset = 0;
  List<Bid> _currentPage;

  BidIterator({
    @required this.size,
    @required this.auctionId,
  });

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
