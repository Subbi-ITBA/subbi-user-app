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
    var jsons = await ServerApi.instance().getProfileAuctions(
      ofUid: ofUid,
    );

    return jsons.map((json) => _fromJson(json));
  }

  /* ------------------------------------------------------------
    Get latest auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getLatestAuctions(
      String category, int limit, int offset) async {
    print('enter serverapi');
    var jsons = await ServerApi.instance().getAuctionsBySort(
<<<<<<< HEAD
        category: category, limit: limit, offset: offset, sort: 'latest');
=======
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.LATEST,
    );
>>>>>>> c0c9680a82c28340cca1e6cd88bc13a15afde898

//    return jsons.map((json) => _fromJson(json));
    return null;
  }

  /* ------------------------------------------------------------
    Get popular auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getPopularAuctions(
      String category, int limit, int offset) async {
    var jsons = await ServerApi.instance().getAuctionsBySort(
<<<<<<< HEAD
        category: category, limit: limit, offset: offset, sort: 'popularity');
=======
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.POPULARITY,
    );
>>>>>>> c0c9680a82c28340cca1e6cd88bc13a15afde898

//    return jsons.map((json) => _fromJson(json));
    return null;
  }

  /* ------------------------------------------------------------
    Get ending auctions
  ------------------------------------------------------------ */

  static Future<List<Auction>> getEndingAuctions(
      String category, int limit, int offset) async {
    var jsons = await ServerApi.instance().getAuctionsBySort(
<<<<<<< HEAD
        category: category, limit: limit, offset: offset, sort: 'deadline');
=======
      category: category,
      limit: limit,
      offset: offset,
      sort: AuctionSort.DEADLINE,
    );
>>>>>>> c0c9680a82c28340cca1e6cd88bc13a15afde898

//    return jsons.map((json) => _fromJson(json));
    return null;
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVING BIDS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get current bids, fetch them if they haven't already
  ------------------------------------------------------------ */

  Future<List<Bid>> getCurrentBids() async {
<<<<<<< HEAD
    if (_bids == null) _bids = await Bid.getCurrentBids(auctionId: auctionId);
=======
    if (_bids == null)
      _bids = await Bid.getCurrentBids(
        auctionId: auctionId,
      );
>>>>>>> c0c9680a82c28340cca1e6cd88bc13a15afde898
    // Fetch bids from server

    return _bids;
  }

  /* ------------------------------------------------------------
    Get a stream of bids
  ------------------------------------------------------------ */

<<<<<<< HEAD
  Stream<Bid> subscribeToBids() => Bid.getBidsStream(auctionId: auctionId);
=======
  Stream<Bid> subscribeToBids() => Bid.getBidsStream(
        auctionId: auctionId,
      );

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 MANAGING AUCTION
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Post an auction
  ------------------------------------------------------------ */

  Future<void> post() =>
      ServerApi.instance().postAuction(auctionJson: _toJson());

  /* ------------------------------------------------------------
    Delete an auction
  ------------------------------------------------------------ */

  Future<void> delete() => ServerApi.instance().deleteAuction(
        auctionId: auctionId,
      );
>>>>>>> c0c9680a82c28340cca1e6cd88bc13a15afde898

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 SERIALIZATION
  ------------------------------------------------------------------------------------------------------------------------ */

  Map<String, dynamic> _toJson() => throw UnimplementedError();

  static Auction _fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
