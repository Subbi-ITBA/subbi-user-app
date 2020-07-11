import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:subbi/models/auction/bid.dart';
import 'package:subbi/models/profile/profile.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/unauthenticated_box.dart';

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
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Body(
        auction: auction,
      ),
      bottomNavigationBar: AuctionInfo(
        auction: auction,
      ),
    );
  }
}

class Body extends StatelessWidget {
  final Auction auction;
  Body({@required this.auction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ImageSlider(
            photoIds: this.auction.photosIds,
          ),
          Flexible(
            fit: FlexFit.loose,
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
                  Divider(
                    color: Colors.grey,
                  ),
                  ProfileInfo(
                    profileId: auction.ownerUid,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  AuctionDescription(
                    auction: this.auction,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  BidList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuctionDescription extends StatelessWidget {
  final Auction auction;
  AuctionDescription({@required this.auction});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Descripción",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
      Row(children: <Widget>[
        Flexible(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.auction.description,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                )))
      ])
    ]));
  }
}

class BidList extends StatefulWidget {
  @override
  _BidListState createState() => _BidListState();
}

class _BidListState extends State<BidList> {
  List<Bid> bidList;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Pujas",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              BidderInfo(
                bid: null,
              ),
              BidderInfo(
                bid: null,
              ),
              BidderInfo(
                bid: null,
              ),
              BidderInfo(
                bid: null,
              ),
              BidderInfo(
                bid: null,
              )
            ],
          ),
        ),
      ],
    ));
  }
}

class BidderInfo extends StatelessWidget {
  final Bid bid;

  BidderInfo({@required this.bid});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
                  ),
                ),
              ),
              Text(
                "Susana Horia",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                "25-07-2020 18:65:65",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Text(
                "\$35",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }
}

class ProfileInfo extends StatelessWidget {
  final String profileId;

  const ProfileInfo({
    Key key,
    @required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: Profile.getProfile(
          ofUid: profileId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Profile profile = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Vendedor",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/profile',
                        arguments: profile,
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: CircleAvatar(
                                radius: 25,
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
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  profile.name,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Nuestro experto",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                "Clark Kent",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class AuctionInfo extends StatelessWidget {
  static const BID_PAGE_SIZE = 20;
  final Auction auction;

  AuctionInfo({@required this.auction});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var bidIterator = auction.getBidIterator(pageSize: BID_PAGE_SIZE);

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
                  FutureBuilder<bool>(
                    future: bidIterator.moveNext(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: null,
                        );
                      }

                      var bids = bidIterator.current;
                      bids.sort((b1, b2) => b1.amount.compareTo(b2.amount));

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                        child: Text(
                          bids.isNotEmpty
                              ? bids.last.amount.toString()
                              : "Ninguna",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), //this right here
                          child: _buildBidDialog(context, auction),
                          // StreamBuilder<Bid>(
                          //   stream: Bid.getBidsStream(
                          //       auctionId: this.auction.auctionId),
                          //   builder: (context, snapshot) {
                          //     switch (snapshot.connectionState) {
                          //       case ConnectionState.waiting:
                          //       case ConnectionState.none:
                          //         return LinearProgressIndicator();
                          //       case ConnectionState.active:
                          //       case ConnectionState.done:
                          //         return BidDialog(highestBid: snapshot.data);
                          //     }
                          //     return null;
                          //   },
                          // )
                        );
                      });
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                icon: Icon(Icons.gavel),
                label: Text(
                  "Pujar".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                  ),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DeadlineTimer(
                auction: this.auction,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildBidDialog(context, auction) {
  var user = Provider.of<User>(context);
  if (!user.isSignedIn()) {
    return UnauthenticatedBox();
  } else {
    return BidDialog(auction: auction);
  }
}

class BidDialog extends StatefulWidget {
  Auction auction;

  BidDialog({@required this.auction});
  @override
  _BidDialogState createState() => _BidDialogState(auction: this.auction);
}

class _BidDialogState extends State<BidDialog> {
  final Auction auction;
  Bid highestBid = new Bid(
      amount: 20,
      auctionId: 50,
      date: DateTime.now(),
      placerUid: 'x0KcL7oixqaJXKMq6c9DTX4XBio2');
  double bidAmount;
  int _state = 0;
  final _formKey = GlobalKey<FormState>();

  _BidDialogState({@required this.auction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    // hintText: "Puja mínima: \$"+highestBid.amount.toString(),
                    hintText: "Mayor puja:${highestBid.amount}",
                    labelText: "Puja",
                  ),
                  onChanged: (String newValue) {
                    this.bidAmount = double.parse(newValue);
                  },
                  validator: (value) => value.isEmpty
                      ? "La puja no puede ser vacía"
                      : double.parse(value) <= highestBid.amount
                          ? "La puja debe ser mayor a ${highestBid.amount}"
                          : null),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                //Wrap with Material
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                elevation: 8.0,
                color: Colors.deepPurple,
                clipBehavior: Clip.antiAlias, // Add This
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 35,
                  color: Colors.deepPurple,
                  child: setUpButtonChild(),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _state = 1;
                      });
                      ServerApi.instance()
                          .postBid(
                              auctionId: this.auction.auctionId,
                              amount: bidAmount)
                          .then((value) => {Navigator.pop(context)});
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Enviar puja".toUpperCase(),
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}

class DeadlineTimer extends StatelessWidget {
  final Auction auction;

  DeadlineTimer({@required this.auction});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
          Duration(
            seconds: 1,
          ),
          (i) => i),
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
                    color: Theme.of(context).accentColor,
                    fontSize: 12,
                  ),
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
  final List<int> photoIds;

  ImageSlider({@required this.photoIds});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.35,
        aspectRatio: 16 / 9,
        viewportFraction: 0.5,
        initialPage: 0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
      items: this.photoIds.map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: Image.network(
                    'https://subbi.herokuapp.com/photo/$i.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
