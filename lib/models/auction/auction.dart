import 'package:flutter/material.dart';
import 'package:subbi/models/profile/profile.dart';

import 'bid.dart';

class Auction {
  String title;
  String description;
  String imageURL;
  DateTime deadLine;
  String ownerUid;

  List<Bid> _bids;

  Auction(
      {@required this.title,
      @required this.imageURL,
      @required this.deadLine,
      @required this.ownerUid});

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
}
