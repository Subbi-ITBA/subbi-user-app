import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/ads_carrousel.dart';
import 'package:subbi/models/user.dart';
import 'package:provider/provider.dart';
import 'package:subbi/widgets/auction_card.dart';
import 'package:subbi/widgets/category_list.dart';
import 'auction_list_by_sort.dart';

class HomeScreen extends StatefulWidget {
  static const AUCTIONS_TO_SHOW = 4;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuctionIterator popularAuctionsIterator = Auction.getPopularAuctions(
    category: null,
    pageSize: HomeScreen.AUCTIONS_TO_SHOW,
  );

  final AuctionIterator latestAuctionsIterator = Auction.getLatestAuctions(
    category: null,
    pageSize: HomeScreen.AUCTIONS_TO_SHOW,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/logo-white.png',
            scale: 0.8,
          ),
          splashColor: Colors.transparent,
          onPressed: () {},
        ),
        title: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            isDense: true,
            filled: true,
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.search),
            hintText: 'Buscar productos',
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Provider.of<User>(context).signOut();
              print('Signed out');
            },
            icon: Icon(Icons.notifications_none),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: AdsCarrousel(),
            ),
            user.isSignedIn()
                ? Container()
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Create una cuenta para tener una mejor experiencia!',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/signin');
                              setState(() {});
                            },
                            child: Text('Crear una cuenta'),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/signin');
                              setState(() {});
                            },
                            child: Text(
                              'Ya tengo una cuenta',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Categorías',
                        style: TextStyle(fontSize: 20),
                      ),
                      CategoryList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Más populares',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AuctionListBySortScreen.route,
                                arguments: {
                                  'title': 'Más populares',
                                  'sort': "popularity",
                                },
                              );
                            },
                            child: Text(
                              'Ver más',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      FutureBuilder<List<Auction>>(
                        future: popularAuctionsIterator.current,
                        builder: (context, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snap.hasData && snap.data.isNotEmpty) {
                            var _auctions = snap.data;

                            return GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: _auctions.length,
                              itemBuilder: (context, i) {
                                return AuctionCard(
                                  auction: _auctions.elementAt(i),
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Center(
                                  child: Text('Todavía no hay subastas activas',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.deepPurple))),
                            );
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Novedades',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AuctionListBySortScreen.route,
                                arguments: {
                                  'title': 'Novedades',
                                  'sort': "latest",
                                },
                              );
                            },
                            child: Text(
                              'ver más',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      FutureBuilder<List<Auction>>(
                        future: latestAuctionsIterator.current,
                        builder: (context, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snap.hasData && snap.data.isNotEmpty) {
                            var _auctions = snap.data;

                            return GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: _auctions.length,
                              itemBuilder: (context, i) {
                                return AuctionCard(
                                  auction: _auctions.elementAt(i),
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Center(
                                  child: Text('Todavía no hay subastas activas',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.deepPurple))),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
