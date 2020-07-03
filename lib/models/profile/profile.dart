import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile_rating.dart';
import '../user.dart';

class Profile {
  User user;
  String uid;
  String name;
  String profilePicURL;
  String location;

  List<ProfileRating> _ratings;
  List<Auction> _pastAuctions;

  bool following;

  Profile({
    @required this.user,
    @required this.uid,
    @required this.name,
    @required this.profilePicURL,
    @required this.location,
    @required this.following,
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
    return ServerApi.instance().getProfile(ofUid: ofUid);
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 FOLLOW
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Follow this user
  ------------------------------------------------------------ */

  Future<void> follow() async {
    return ServerApi.instance().followProfile(
      uid: user.fbUser.uid,
      followUid: uid,
      follow: true,
    );
  }

  /* ------------------------------------------------------------
    Unfollow this user
  ------------------------------------------------------------ */

  Future<void> unfollow() async {
    return ServerApi.instance().followProfile(
      uid: user.fbUser.uid,
      followUid: uid,
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
      _ratings = await ProfileRating.getRatings(uid);
    }

    return _ratings;
  }

  /* ------------------------------------------------------------
    Rate this user
  ------------------------------------------------------------ */

  void rate(
    String comment,
    int rate,
  ) {
    var newRating = ProfileRating(
      comment: comment,
      rate: rate,
      date: DateTime.now(),
      ratedUserProfile: this,
      ratingUserProfile: user.profile,
    );

    _ratings.add(newRating);

    newRating.post();
  }

  /* ------------------------------------------------------------------------------------------------------------------------
                                                 PAST AUCTIONS
  ------------------------------------------------------------------------------------------------------------------------ */

  /* ------------------------------------------------------------
    Get user's past auctions, fetch them if they haven't already
  ------------------------------------------------------------ */

  Future<List<Auction>> get pastAuctions async {
    if (_pastAuctions == null) {
      _pastAuctions = await Auction.getAuctions(uid);
    }

    return _pastAuctions;
  }
}
