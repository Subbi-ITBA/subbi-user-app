import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/widgets/auction_card.dart';
import 'package:subbi/screens/main_screen.dart';
import 'package:subbi/widgets/cross_shrinked_listview.dart';

import '../unauthenticated_box.dart';

class OwnAuctionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    if (!user.isSignedIn()) {
      return UnauthenticatedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Subastas'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
              child: Text(
                'Subastas en las que participás',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            FutureBuilder<List<Auction>>(
              future: Auction.getParticipatingAuctions(user.getUID()),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var auctions = snap.data;

                if (auctions.isEmpty) {
                  return Container(
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
                            onPressed: () {
                              DefaultTabController.of(context)
                                  .animateTo(MainScreen.HOME_TAB);
                            },
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
                  );
                } else {
                  return CrossShrinkedListView(
                    alignment: Axis.horizontal,
                    itemCount: auctions.length,
                    itemBuilder: (int index) {
                      return AuctionCard(
                        auction: auctions[index],
                      );
                    },
                  );
                }
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 7, 0, 7),
              child: Text(
                'Subastas que creaste',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            FutureBuilder<List<Auction>>(
              future: Auction.getProfileAuctions(user.getUID()),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var auctions = snap.data;

                if (auctions.isEmpty) {
                  return Container(
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
                            onPressed: () {
                              DefaultTabController.of(context)
                                  .animateTo(MainScreen.ADD_AUCTION);
                            },
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
                  );
                } else {
                  return CrossShrinkedListView(
                    alignment: Axis.horizontal,
                    itemCount: auctions.length,
                    itemBuilder: (int index) {
                      return AuctionCard(
                        auction: auctions[index],
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
