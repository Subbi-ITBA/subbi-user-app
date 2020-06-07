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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,

          leading: Transform.scale(
            scale: 0.8,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back,
                  size: 35, color: Theme.of(context).primaryColor),
            ),
          ),

          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.more, color: Theme.of(context).primaryColor),
          //       onPressed: () => Navigator.pop(context)),
          // ],
        ),
        body: Body(auction: this.auction));
  }
}

class Body extends StatelessWidget {
  final Auction auction;
  Body({@required this.auction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Column(
          children: <Widget>[
            ImageSlider(imageUrl: this.auction.imageURL),
            SizedBox(height: 30),
            Expanded(
                child: Container(
              width: size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: double.infinity, height: 25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 3),
                    child: Text(
                      this.auction.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
        Positioned.fill(
            top: 260,
            child: Align(
                alignment: Alignment.topCenter,
                child: Timer(auction: this.auction)))
      ],
    );
  }
}

class Timer extends StatelessWidget {
  final Auction auction;
  Timer({@required this.auction});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: 75,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 4.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          )),
    );
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ImageSlider extends StatelessWidget {
  final List<String> imageUrl;

  ImageSlider({@required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CarouselSlider(
        options: CarouselOptions(
          height: size.height * 0.4,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
        items: this.imageUrl.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.all(15.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child:
                        Image.network('$i', fit: BoxFit.fill, width: 1000.0)),
              );
            },
          );
        }).toList());
  }
}
