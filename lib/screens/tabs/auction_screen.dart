import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuctionScreen extends StatelessWidget {
  Map data = {};
  Auction auction;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    this.auction = this.data['auction'];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.4),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: this.auction.imageURL.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network('$i',
                          height: size.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.fill);
                    },
                  );
                }).toList()),
            leading: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.pop(context)),
              ),
            ),

            // actions: <Widget>[
            //   IconButton(
            //       icon: Icon(Icons.more, color: Theme.of(context).primaryColor),
            //       onPressed: () => Navigator.pop(context)),
            // ],
          ),
        ),
        body: Body(auction: this.data['auction']));
  }
}

class Body extends StatelessWidget {
  final Auction auction;
  Body({@required this.auction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          width: size.width,
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)))),
        )
      ],
    );
  }
}
