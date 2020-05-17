import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';

import 'package:subbi/screens/unauthenticated_box.dart';
import 'package:subbi/widgets/auctionList.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class OwnAuctionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    // testing
    final cantAuct = 0;
    final cantBids = 0;

    if (!user.isSignedIn()) return UnauthenticatedBox();

    return Scaffold(
        body: SafeArea(
            child: ListView(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
            child: Text(
              'Subastas activas',
              style: Theme.of(context).textTheme.title,
            )),
        Conditional.single(
            context: context,
            conditionBuilder: (context) => cantBids == 0,
            widgetBuilder: (context) => Center(
                child: Container(
                    width: 300,
                    child: Card(
                        margin: EdgeInsets.fromLTRB(10, 70, 10, 70),
                        elevation: 2,
                        child: ListTile(
                            title: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                                child: Text("No participas en ninguna subasta!",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            subtitle: Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                              child: RaisedButton(
                                onPressed: () {},
                                child: const Text('Ver subastas',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ))))),
            fallbackBuilder: (context) => Container(child: AuctionList())),
        Container(
          padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
          child: Text(
            'Tus subastas',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Conditional.single(
            context: context,
            conditionBuilder: (context) => cantAuct == 0,
            widgetBuilder: (context) => Center(
                child: Container(
                    width: 300,
                    child: Card(
                        margin: EdgeInsets.fromLTRB(10, 70, 10, 70),
                        elevation: 2,
                        child: ListTile(
                            title: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                                child: Text("No tienes ninguna subasta activa!",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            subtitle: Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                              child: RaisedButton(
                                onPressed: () {},
                                child: const Text('Enviar lote',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ))))),
            fallbackBuilder: (context) => Container(child: AuctionList()))
      ],
    )));
  }
}
