import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/ads_carrousel.dart';
import 'package:subbi/models/user.dart';
import 'package:provider/provider.dart';
import 'package:subbi/widgets/auction_card.dart';
import 'package:subbi/widgets/category_list.dart';
import 'auction_list_by_sort.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

class HomeScreen extends StatefulWidget {
  static const String MP_PUBLIC_KEY =
      "TEST-b501df4e-24d0-4f27-8864-21a4e789bb22";
  static const String PREFERENCE_ID =
      "293458878-e967c4cf-0a9b-4294-9d12-e53b1dcc5198";
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
            RaisedButton(
              onPressed: () {
                mp(context);
              },
              child: Text('pagar'),
            ),
            FlatButton(child: Text('show winner dialog'), onPressed: (){showWinnerDialog(context);},),
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
                        },
                      ),
                      // TODO new auctions
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

  void mp(BuildContext context) async {
    PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
      HomeScreen.MP_PUBLIC_KEY,
      HomeScreen.PREFERENCE_ID,
    );
    print(result.toString());
    showDialog(
      context: context,
      builder: (buildContext) {
        if (result.statusDetail == "accredited") {
          return AlertDialog(
            title: Text('Payment received'),
            content: Text('el que lee es gay'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
                child: Text('CLOSE'),
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Payment failed'),
            content: Text('el que lee es gay'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                  mp(context);
                },
                child: Text('TRY AGAIN'),
              )
            ],
          );
        }
      },
    );
  }

  void showWinnerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Center(child: Text('Finalizó la subasta de Auto volador')),
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Fuiste el mayor postor con una puja de \$400'),
                Text('Contactate con el vendedor'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage('https://www.google.com/url?sa=i&url=https%3A%2F%2Fhappytravel.viajes%2Fhappytravel-opiniones%2Fattachment%2F146-1468479_my-profile-icon-blank-profile-picture-circle-hd%2F&psig=AOvVaw0reWr7NuYshsqiL6xdoPV7&ust=1594069920312000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNiRq7uDt-oCFQAAAAAdAAAAABAe'),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(onTap: (){}, child: Text('Javier James Joliwood', style: TextStyle(decoration: TextDecoration.underline,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),)),
                      InkWell(onTap: (){}, child: Icon(Icons.message),)
                    ],
                  ),
                ],)
              ],),
            actions: <Widget>[
              RaisedButton(
                onPressed: (){},
                child: Text('Pagar con MercadoPago', style: TextStyle(color: Colors.white),),
                color: Colors.lightBlueAccent,
              )
            ],
          );
        }
    );
  }
}
