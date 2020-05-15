import 'package:flutter/material.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/profile/profile_rating.dart';

import '../user.dart';
import 'chat.dart';

class Profile{

  User user;
  String uid;
  String name;
  String profilePicURL;
  String location;

  List<ProfileRating> ratings;
  List<Auction> pastAuctions;

  Chat chat;
  bool following;

  Profile({@required this.user, @required this.uid, @required this.name, @required this.profilePicURL, @required this.location,
    @required this.ratings, @required this.pastAuctions, @required this.chat, @required this.following});


  Future<void> rate(int rate) => throw UnimplementedError();

  Future<void> follow() => throw UnimplementedError();

  Future<void> unfollow() => throw UnimplementedError();

}