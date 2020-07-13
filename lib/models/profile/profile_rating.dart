import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';

class ProfileRating {
  String raterUid;
  String ratedUid;

  double rate;
  String comment;
  DateTime date;

  ProfileRating({
    @required this.raterUid,
    @required this.ratedUid,
    @required this.rate,
    @required this.comment,
    @required this.date,
  });

  Future<void> post() async {
    await ServerApi.instance().rateProfile(
      ratedUid: ratedUid,
      comment: comment,
      rate: rate,
    );
  }

  static Future<List<ProfileRating>> getRatings(String ofUid) async {
    return await ServerApi.instance().getRatings(
      ofUid: ofUid,
    );
  }
}
