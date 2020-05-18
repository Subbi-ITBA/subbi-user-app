import 'package:flutter/material.dart';
import 'package:subbi/models/profile/profile.dart';

import '../user.dart';

class ProfileRating{

  Profile ratingUserProfile;
  Profile ratedUserProfile;
  
  int rate;
  String comment;
  DateTime date;

  ProfileRating({@required this.ratingUserProfile, @required this.ratedUserProfile, @required this.rate, @required this.comment, @required this.date});


  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

}