import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/auction/bid.dart';
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
  List<Auction> _pastAuctions;
  List<Bid> _active_Bids;

  Chat chat;
  bool following;

  Profile({@required this.user, @required this.uid, @required this.name, @required this.profilePicURL, @required this.location,
    @required this.chat, @required this.following, ratings, pastAuctions}){

      // TODO: Remove this, it's only for mocking purposes
      this._ratings = ratings;
      this._pastAuctions = pastAuctions;

  }


  Future<void> follow() => ServerApi.instance().followProfile(
    uid: user.fbUser.uid, followUid: uid, follow: true
  );


  Future<void> unfollow() => ServerApi.instance().followProfile(
    uid: user.fbUser.uid, followUid: uid, follow: false
  );


  void rate(String comment, int rate){

    var newRating = ProfileRating(
      comment: comment,
      rate: rate,
      date: DateTime.now(),
      ratedUserProfile: this,
      ratingUserProfile: user.profile
    );

    _ratings.add(newRating);

    newRating.post();

  }

  /* ------------------------------------------------------------
    Fetches ratings if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<ProfileRating>> get ratings async{

    if(_ratings==null){
      _ratings = await ProfileRating.getRatings(uid);
    }

    return _ratings;
  }

  /* ------------------------------------------------------------
    Fetches past auctions if they haven't been fetched already
  ------------------------------------------------------------ */

  Future<List<Auction>> get pastAuctions async{

    if(_pastAuctions==null){
      _pastAuctions = await Auction.getAuctions(uid);
    }

    return _pastAuctions;

  }
}
