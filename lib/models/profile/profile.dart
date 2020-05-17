import 'package:flutter/material.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile_rating.dart';

import '../user.dart';
import 'chat.dart';

class Profile {
  User user;
  String uid;
  String name;
  String profilePicURL;
  String location;

  List<ProfileRating> _ratings;
  List<Auction> _auctions;

  Chat chat;
  bool following;

  Profile(
      {@required this.user,
      @required this.uid,
      @required this.name,
      @required this.profilePicURL,
      @required this.location,
      @required this.chat,
      @required this.following});

  Future<void> follow() => throw UnimplementedError();

  Future<void> unfollow() => throw UnimplementedError();

  void rate(int rate) => throw UnimplementedError();

  /* ------------------------------------------------------------
    Fetches ratings if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<ProfileRating>> get ratings async {
    if (_ratings == null) ;
    // Fetch ratings from server

    return _ratings;
  }

  /* ------------------------------------------------------------
    Fetches past auctions if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<Auction>> get auctions async {
    if (_auctions == null) ;
    // Fetch past auctions from server

    return _auctions;
  }
}
