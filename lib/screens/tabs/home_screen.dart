import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/widgets/ads_carrousel.dart';
import 'package:subbi/widgets/category_list.dart';
import 'package:subbi/widgets/auction_list.dart';
import 'package:subbi/models/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset('assets/logo-white.png', scale: 0.8),
              splashColor: Colors.transparent,
              onPressed: () {}),
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Buscar productos'
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
//                    borderSide: BorderSide(color: Colors.grey),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
//                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
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
                      ? Container(height: 0, width: 0)
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Create una cuenta para tener una mejor experiencia!',
                                  style: TextStyle(fontSize: 15),
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
                  CategoryList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Más populares', style: TextStyle(fontSize: 20)),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Ver más',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      )
                    ],
                  ),
                  // TODO most popular auctions
                  AuctionList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Novedades', style: TextStyle(fontSize: 20)),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'ver más',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      )
                    ],
                  )
                  // TODO new auctions
                ],
              ),
            ),
    ])
      )
    );
  }
}
