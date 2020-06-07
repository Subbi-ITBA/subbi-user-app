import 'package:flutter/material.dart';
import 'package:subbi/widgets/ads_carrousel.dart';
import 'package:subbi/widgets/category_list.dart';
import 'package:subbi/widgets/auction_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset('assets/logo-white.png', scale: 0.8),
              splashColor: Colors.transparent,
              onPressed: () {}),
          title: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar productos',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AdsCarrousel(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text('Categories', style: TextStyle(fontSize: 20)),
                ),
                CategoryList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Más populares', style: TextStyle(fontSize: 20)),
                    GestureDetector(onTap: (){},child: Text('Ver más', style: TextStyle(color: Colors.deepPurpleAccent)))
                  ],
                ),
                AuctionList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Novedades', style: TextStyle(fontSize: 20)),
                    GestureDetector(onTap: (){},child: Text('ver más', style: TextStyle(color: Colors.deepPurpleAccent)))
                  ],
                ),
              ],
            ),
          ),
        ));
    // return Column(
    //   children: [

    //     Container(
    //       height: 100,
    //       child: AppBar(),
    //     ),

    //     Expanded(
    //       child: Center(
    //         child: Text('Hello'),
    //       ),
    //     )

    //   ]
    // );
  }
}
