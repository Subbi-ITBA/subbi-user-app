import 'package:flutter/material.dart';
import 'package:subbi/models/profile/profile.dart';

import '../user.dart';

class ProfileRating{

  User user;
  Profile ratedProfile;
  
  int rate;
  String comment;
  DateTime date;

  ProfileRating({@required this.ratedProfile, @required this.user, @required this.rate, @required this.comment, @required this.date});


  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

}