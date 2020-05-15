import 'package:flutter/material.dart';
import 'package:subbi/models/profile/profile.dart';

import 'bid.dart';

class Auction{

  String title;
  String imagesURL;
  Profile owner;
  DateTime deadLine;
  List<Bid> bids;

  Auction({@required this.title, @required this.imagesURL, @required this.owner, @required this.deadLine, @required this.bids});

  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

}