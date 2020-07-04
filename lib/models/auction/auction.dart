import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'bid.dart';

class Auction {
  int auctionId;
  String ownerUid;
  String title;
  String description;
  String category;
  List<String> imageURL;
  DateTime deadLine;
  int quantity;
  double initialPrice;

  Auction({
    @required this.auctionId,
    @required this.ownerUid,
    @required this.title,
    @required this.description,
    @required this.category,
    @required this.imageURL,
    @required this.deadLine,
    @required this.quantity,
    @required this.initialPrice,
  });

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING AUCTIONS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get auctions of a profile
  ------------------------------------------------------------ */

  static Future<List<Auction>> getProfileAuctions(String ofUid) async {
    return await ServerApi.instance().getProfileAuctions(
      ofUid: ofUid,
    );
  }

  /* ------------------------------------------------------------
    Get the auctions on which the user participates
  ------------------------------------------------------------ */

  static Future<List<Auction>> getParticipatingAuctions(String userUid) async {
    return await ServerApi.instance().getParticipatingAuctions();
  }

  /* ------------------------------------------------------------
    Get latest auctions
  ------------------------------------------------------------ */

  static AuctionIterator getLatestAuctions({
    @required String category,
    @required int pageSize,
  }) {
    return AuctionIterator(
      category: category,
      pageSize: pageSize,
      sortMethod: AuctionSort.CREATION_DATE,
    );
  }

  /* ------------------------------------------------------------
    Get popular auctions
  ------------------------------------------------------------ */

  static AuctionIterator getPopularAuctions({
    @required String category,
    @required int pageSize,
  }) {
    return AuctionIterator(
      category: category,
      pageSize: pageSize,
      sortMethod: AuctionSort.POPULARITY,
    );
  }

  /* ------------------------------------------------------------
    Get ending auctions
  ------------------------------------------------------------ */

  static AuctionIterator getEndingAuctions({
    @required String category,
    @required int pageSize,
  }) {
    return AuctionIterator(
      category: category,
      pageSize: pageSize,
      sortMethod: AuctionSort.DEADLINE,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING BIDS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get current bids, fetch them if they haven't already
  ------------------------------------------------------------ */

  BidIterator getBidIterator({
    @required int pageSize,
  }) {
    return Bid.getBidIterator(
      auctionId: auctionId,
      pageSize: pageSize,
    );
  }

  /* ------------------------------------------------------------
    Get a stream of bids
  ------------------------------------------------------------ */

  Stream<Bid> subscribeToBids() {
    return Bid.getBidsStream(
      auctionId: auctionId,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 MANAGING AUCTION
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Post an auction
  ------------------------------------------------------------ */

  Future<void> post() {
    return ServerApi.instance().postLot(
      title: title,
      description: description,
      category: category,
      quantity: quantity,
      initialPrice: initialPrice,
    );
  }
}

class AuctionIterator {
  final AuctionSort sortMethod;
  final String category;
  final int pageSize;

  int _offset = 0;

  AuctionIterator({
    @required this.category,
    @required this.sortMethod,
    @required this.pageSize,
  });

  Future<List<Auction>> get current async {
    return await ServerApi.instance().getAuctionsBySort(
      category: category,
      sort: sortMethod,
      offset: _offset,
      limit: pageSize,
    );
  }

  Future<bool> moveNext() async {
    _offset += pageSize;
    return true;
  }
}
