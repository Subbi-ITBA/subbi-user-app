import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';

import 'package:subbi/screens/unauthenticated_box.dart';
import 'package:subbi/widgets/auction_list.dart';

class OwnAuctionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    // testing
    final cantAuct = 1;
    final cantBids = 1;

    // if (!user.isSignedIn()) return UnauthenticatedBox();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
              child: Text(
                'Subastas activas',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            cantBids == 0
                ? Container(
                    width: 300,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 70, 10, 70),
                      elevation: 2,
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          child: Text(
                            "No participas en ninguna subasta!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          child: RaisedButton(
                            onPressed: () {},
                            child: const Text(
                              'Ver subastas',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: AuctionList(
                      type: "null",
                    ),
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
              child: Text(
                'Tus subastas',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            cantAuct == 0
                ? Container(
                    width: 300,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 70, 10, 70),
                      elevation: 2,
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          child: Text(
                            "No tienes ninguna subasta activa!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          child: RaisedButton(
                            onPressed: () {},
                            child: const Text(
                              'Enviar lote',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: AuctionList(
                      type: "active",
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
