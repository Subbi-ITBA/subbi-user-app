import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:subbi/models/auction/bid.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/models/user.dart';

Map data;

class AuctionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Auction auction = data['auction'];
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Body(auction: auction),
      bottomNavigationBar: AuctionInfo(auction: auction),
    );
  }
}

class Body extends StatelessWidget {
  final Auction auction;
  Body({@required this.auction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        ImageSlider(imageUrl: this.auction.imageURL),
        Expanded(
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    this.auction.title,
                    softWrap: true,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                UserInfo(userId: auction.ownerUid),
                Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class Body2 extends StatelessWidget {
//   final Auction auction;
//   Body2({@required this.auction,});
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Column(
//       children: <Widget>[
//         Container(
//           height: size.height * 0.4,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: size.height * 0.4 - 50,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(this.auction.imageURL.first),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class UserInfo extends StatelessWidget {
  final String userId;

  const UserInfo({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: Profile.getProfile(ofUid: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        Profile profile = snapshot.data;

        return Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      profile.profilePicURL,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      profile.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
      height: 87,
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
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Puja actual:",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FutureBuilder<List<Bid>>(
                    future: Bid.getCurrentBids(auctionId: auction.auctionId),
                    builder: (context, snap) {

                      if(snap.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var bids = snap.data;
                      bids.sort((b1, b2) => b1.amount.compareTo(b2.amount));

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                        child: Text(
                          bids.last.amount.toString(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ],
              ),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                icon: Icon(Icons.gavel),
                label: Text(
                  "Pujar".toUpperCase(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  "Termina en:",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              DeadlineTimer(auction: this.auction),
            ],
          ),
        ],
      ),
    );
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
        Duration leftingTime = this.auction.deadLine.difference(DateTime.now());
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).accentColor,
                  ),
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
                  "Días",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 12),
                ),
              ],
            ),
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
                    color: Theme.of(context).accentColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      hoursString,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Horas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 12,
                  ),
                ),
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
                    color: Theme.of(context).accentColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      minutesString,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Minutos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 0, 15),
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
                    color: Theme.of(context).accentColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      secondsString,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Segundos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
        height: size.height * 0.37,
        aspectRatio: 16 / 9,
        viewportFraction: 0.65,
        initialPage: 0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
      items: this.imageUrl.map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network('$i', fit: BoxFit.fill),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
