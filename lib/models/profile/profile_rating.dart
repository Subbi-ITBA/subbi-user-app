import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';

class ProfileRating {
  String ratedUid;

  int rate;
  String comment;
  DateTime date;

  ProfileRating({
    @required this.ratedUid,
    @required this.rate,
    @required this.comment,
    @required this.date,
  });

  Future<void> post() async {
    await ServerApi.instance().rateProfile(
      rateUid: ratedUid,
      rate: rate,
    );
  }

  static Future<List<ProfileRating>> getRatings(String ofUid) async {
    return await ServerApi.instance().getRatings(
      ofUid: ofUid,
    );
  }
}
