import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'bid.dart';

class Auction {
  String auctionId;
  String ownerUid;
  String title;
  String description;
  String category;
  List<String> imageURL;
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
    @required this.initialPrice,
  });

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING AUCTIONS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get auctions of a profile
  ------------------------------------------------------------ */

  static Future<List<Auction>> getAuctions(String ofUid) async {
    return await ServerApi.instance().getProfileAuctions(
      ofUid: ofUid,
    );
  }

  /* ------------------------------------------------------------
    Get latest auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getLatestAuctions(
    String category,
    int limit,
    int offset,
  ) async {
    return await ServerApi.instance().getAuctionsBySort(
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.CREATION_DATE,
    );
  }

  /* ------------------------------------------------------------
    Get popular auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getPopularAuctions(
    String category,
    int limit,
    int offset,
  ) async {
    return await ServerApi.instance().getAuctionsBySort(
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.POPULARITY,
    );
  }

  /* ------------------------------------------------------------
    Get ending auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getEndingAuctions(
    String category,
    int limit,
    int offset,
  ) async {
    return await ServerApi.instance().getAuctionsBySort(
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.DEADLINE,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING BIDS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get current bids, fetch them if they haven't already
  ------------------------------------------------------------ */

  Future<List<Bid>> getCurrentBids() async {
    if (_bids == null)
      _bids = await Bid.getCurrentBids(
        auctionId: auctionId,
      );

    return _bids;
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
