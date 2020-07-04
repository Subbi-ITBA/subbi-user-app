import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/screens/tabs/auction_list_by_sort.dart';
import 'package:subbi/widgets/ads_carrousel.dart';
import 'package:subbi/widgets/auction_card.dart';
import 'package:subbi/widgets/category_list.dart';
import 'package:subbi/models/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const POPULAR_AUCTIONS_TO_SHOW = 4;

  final AuctionIterator popularAuctionsIterator = Auction.getPopularAuctions(
    category: null,
    pageSize: POPULAR_AUCTIONS_TO_SHOW,
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
        title: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Buscar productos',
            ),
          ),
        ),
//          title: TextField(
//            decoration: InputDecoration(
//                prefixIcon: Icon(Icons.search),
//                hintText: 'Buscar productos',
//                filled: true,
//                fillColor: Colors.white,
//                border: OutlineInputBorder(
//                    borderSide: BorderSide(color: Colors.grey,),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0),),),
//                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),),
//          ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: AdsCarrousel(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  user.isSignedIn()
                      ? Container(
                          height: 0,
                          width: 0,
                        )
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
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signin');
                                  },
                                  child: Text('Crear una cuenta'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signin');
                                  },
                                  child: Text(
                                    'Ya tengo una cuenta',
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Text(
                    'Categorias',
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

                      var _auctions = snap.data;

                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: _auctions.length,
                        itemBuilder: (context, i) {
                          return AuctionCard(
                            auction: _auctions.elementAt(i),
                          );
                        },
                      );
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
                  )
                  // TODO new auctions
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
