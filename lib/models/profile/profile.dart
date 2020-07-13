import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile_rating.dart';
import '../user.dart';

class Profile {
  User user;
  String profileUid;
  String name;
  String profilePicURL;
  String location;

  List<ProfileRating> _ratings;
  List<Auction> _pastAuctions;

  bool following;

  Profile({
    @required this.user,
    @required this.profileUid,
    @required this.name,
    @required this.profilePicURL,
    @required this.location,
    List<ProfileRating> ratings,
  }) {
    this._ratings = ratings;
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RETRIEVE PROFILE
  ------------------------------------------------------------------------------------------------------------------------ */

  static Future<Profile> getProfile({
    @required String ofUid,
  }) {
    return ServerApi.instance().getProfile(
      ofUid: ofUid,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 FOLLOW
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Follow this user
  ------------------------------------------------------------ */

  Future<void> follow() async {
    return ServerApi.instance().followProfile(
      followedUid: profileUid,
      follow: true,
    );
  }

  /* ------------------------------------------------------------
    Unfollow this user
  ------------------------------------------------------------ */

  Future<void> unfollow() async {
    return ServerApi.instance().followProfile(
      followedUid: profileUid,
      follow: false,
    );
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 RATINGS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get ratings of this user, fetch them if they haven't already
  ------------------------------------------------------------ */

  Future<List<ProfileRating>> get ratings async {
    if (_ratings == null) {
      _ratings = await ProfileRating.getRatings(profileUid);
    }

    return _ratings;
  }

  /* ------------------------------------------------------------
    Rate this user
  ------------------------------------------------------------ */

  Future<void> rate({
    @required String comment,
    @required double rate,
    @required String raterUid,
  }) async {
    var newRating = ProfileRating(
      raterUid: raterUid,
      comment: comment,
      rate: rate,
      date: DateTime.now(),
      ratedUid: profileUid,
    );

    _ratings.add(newRating);

    await newRating.post();
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 PAST AUCTIONS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get user's past auctions, fetch them if they haven't already
  ------------------------------------------------------------ */

  Future<List<Auction>> get pastAuctions async {
    if (_pastAuctions == null) {
      _pastAuctions = await Auction.getProfileAuctions(profileUid);
    }

    return _pastAuctions;
  }
}
