import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuctionScreen extends StatelessWidget {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Auction auction = this.data['auction'];
    // Size size = MediaQuery.of(context).size;

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
        body: Body(auction: auction));
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
                      softWrap: true,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
                child: AuctionInfo(auction: this.auction)))
      ],
    );
  }
}

class AuctionInfo extends StatelessWidget {
  final Auction auction;
  AuctionInfo({@required this.auction});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.9,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(this.auction.printHighestBid(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Container(child: DeadlineTimer(auction: this.auction)),
          ],
        ));
  }
}

class DeadlineTimer extends StatelessWidget {
  final Auction auction;
  DeadlineTimer({@required this.auction});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 1), (i) => i),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          Duration leftingTime =
              this.auction.deadLine.difference(DateTime.now());
          int days = leftingTime.inDays;
          int seconds = leftingTime.inSeconds.remainder(60);
          int hours = leftingTime.inHours.remainder(24);
          int minutes = leftingTime.inMinutes.remainder(60);
          String daysSring = days < 10 ? "0$days" : "$days";
          String minutesString = minutes < 10 ? "0$minutes" : "$minutes";
          String hoursString = hours < 10 ? "0$hours" : "$hours";
          String secondsString = seconds < 10 ? "0$seconds" : "$seconds";

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).accentColor),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      daysSring,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Days",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 12),
                )
              ]),
              Padding(
                padding: EdgeInsets.fromLTRB(7, 0, 6, 15),
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).accentColor),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            hoursString,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                  Text(
                    "Hours",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 12),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 1, 15),
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).accentColor),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            minutesString,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                  Text(
                    "Minutes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 12),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  ":",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).accentColor),
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            secondsString,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))),
                  Text(
                    "Seconds",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 12),
                  )
                ],
              ),
            ],
          );
        });
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
