import 'package:flutter/material.dart';
import 'package:subbi/models/profile/profile.dart';

class Bid {
  double amount;

  Profile placer;
  DateTime date;

  Bid({@required this.amount, @required this.placer, @required this.date});

  Future<void> place() => throw UnimplementedError();
}
