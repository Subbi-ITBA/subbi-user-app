import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/profile/profile.dart';

class ProfileRating {
  Profile ratingUserProfile;
  Profile ratedUserProfile;

  int rate;
  String comment;
  DateTime date;

  ProfileRating(
      {@required this.ratingUserProfile,
      @required this.ratedUserProfile,
      @required this.rate,
      @required this.comment,
      @required this.date});

  Future<void> post() => throw UnimplementedError();

  Future<void> delete() => throw UnimplementedError();

  static Future<List<ProfileRating>> getRatings(String ofUid) async {
    var jsons = await ServerApi.instance().getRatings(
      ofUid: ofUid,
    );

    return jsons.map((json) => fromJson(json));
  }

  static ProfileRating fromJson(Map<String, dynamic> json) {}
}
