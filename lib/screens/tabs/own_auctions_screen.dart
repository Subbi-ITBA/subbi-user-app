import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/screens/unauthenticated_box.dart';
import 'package:subbi/widgets/auctionList.dart';

class OwnAuctionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    /* 
    if(! user.isSignedIn())
      return UnauthenticatedBox();
*/

    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Subastas activas',
              style: Theme.of(context).textTheme.title,
            )),
        Container(child: AuctionList()),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Tus subastas',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        // Container(child: AuctionList())
      ],
    )));
  }
}
