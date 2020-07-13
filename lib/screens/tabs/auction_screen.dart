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
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:subbi/widgets/mercadopago_dialog.dart';
import 'dart:async';

import 'package:subbi/widgets/profile_info.dart';

Bid highestBid;
Auction auction;

class AuctionScreen extends StatelessWidget {
  // ignore: close_sinks
  final StreamController<Bid> streamController = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    auction = data['auction'];

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
            onPressed: () => MercadoPagoDialog.showWinnerDialog(
                context, highestBid.amount, auction, "2"),
          ),
        ],
      ),
      body: Body(
        streamController: streamController,
      ),
      bottomNavigationBar: AuctionInfo(
        streamController: streamController,
      ),
    );
  }
}

class Body extends StatelessWidget {
  final StreamController<Bid> streamController;
  Body({@required this.streamController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ImageSlider(
            photoIds: auction.photosIds,
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
                      auction.title,
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
                  OwnerInfo(
                    profileId: auction.ownerUid,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  AuctionDescription(),
                  Divider(
                    color: Colors.grey,
                  ),
                  BidList(streamController: streamController)
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
  AuctionDescription();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Padding(
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
      children: <Widget>[
        Row(children: <Widget>[
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    auction.description,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  )))
        ])
      ],
    );
  }
}

class BidList extends StatefulWidget {
  final StreamController<Bid> streamController;

  BidList({@required this.streamController});

  @override
  _BidListState createState() => _BidListState();
}

class _BidListState extends State<BidList> {
  IO.Socket socket;

  @override
  void dispose() {
    super.dispose();
    if (socket != null && socket.connected) {
      socket.disconnect();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  void initializeSocket() {
    ServerApi.instance().emitSocketEvent('subscribe', auction.auctionId);
    ServerApi.instance().onSocketEvent(
      'bidPublished',
      (data) {
        if (this.mounted) {
          if (data['auc_id'] == auction.auctionId) {
            setState(() {
              widget.streamController.add(highestBid);
            });
          }
        }
      },
    );
    ServerApi.instance().onSocketEvent(
      'auctionClosed',
      (data) {
        if (data['auc_id'] == auction.auctionId) {
          var user = Provider.of<User>(context);
          if (user.isSignedIn() && user.getUID() == data['winner_id']) {
            auction.state = "CLOSED";

            MercadoPagoDialog.showWinnerDialog(
                context,
                double.parse(data['highestBid']),
                auction,
                data['preference_id']);
          }
        }
      },
    );
  }

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
        FutureBuilder<List<Bid>>(
          future: auction.getLatestBids(0, 5),
          builder: (context, snap) {
            if (snap.hasData) {
              List<Bid> bids = snap.data;
              highestBid = bids.isEmpty ? null : bids.first;
              widget.streamController.add(highestBid);
              return Center(
                child: Card(
                    child: bids.length == 0
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Text(
                              "Todavia no hay pujas",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListView.builder(
                                  itemCount: bids.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return BidderInfo(bid: bids[index]);
                                  }),
                            ],
                          )),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        // Card(
        //   child: Column(
        //     children: <Widget>[
        //       BidderInfo(
        //         bid: null,
        //       ),
        //       BidderInfo(
        //         bid: null,
        //       ),
        //       BidderInfo(
        //         bid: null,
        //       ),
        //       BidderInfo(
        //         bid: null,
        //       ),
        //       BidderInfo(
        //         bid: null,
        //       )
        //     ],
        //   ),
        // ),
      ],
    ));
  }
}

class BidderInfo extends StatelessWidget {
  final Bid bid;

  BidderInfo({@required this.bid});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: Profile.getProfile(
          ofUid: bid.placerUid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Profile profile = snapshot.data;

          return Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          profile.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        Text(
                          bid.date.toIso8601String(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "\$" + bid.amount.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}

class OwnerInfo extends StatelessWidget {
  final String profileId;

  const OwnerInfo({
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
                  ProfileInfo(profileId: auction.ownerUid)
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

class HighestBidInfo extends StatefulWidget {
  final StreamController<Bid> streamController;

  HighestBidInfo({@required this.streamController});
  @override
  _HighestBidInfoState createState() => _HighestBidInfoState();
}

class _HighestBidInfoState extends State<HighestBidInfo> {
  @override
  void initState() {
    widget.streamController.stream.listen((event) {
      setState(() {
        highestBid = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return Column(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(
                highestBid != null ? highestBid.amount.toString() : "Ninguna",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        _buildBidButton(user, context)
      ],
    );
  }

  Widget _buildBidButton(User user, BuildContext context) {
    print("signed in = " + user.isSignedIn().toString());
    if (!user.isSignedIn() ||
        (user.isSignedIn() && user.getUID() != auction.ownerUid)) {
      return RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        onPressed: auction.state == "CLOSED"
            ? null
            : () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0)), //this right here
                        child: _buildBidDialog(context),
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
      );
    } else {
      return RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: null,
        icon: Icon(Icons.gavel),
        label: Text(
          "Pujar".toUpperCase(),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      );
    }
  }
}

class AuctionInfo extends StatelessWidget {
  final StreamController<Bid> streamController;
  AuctionInfo({@required this.streamController});

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
          HighestBidInfo(streamController: streamController),
          _buildTimer(),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    if (auction.state == "CLOSED") {
      return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: Text(
            "SUBASTA CERRADA",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    } else {
      return Column(
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
          DeadlineTimer(),
        ],
      );
    }
  }
}

Widget _buildBidDialog(context) {
  var user = Provider.of<User>(context);
  if (!user.isSignedIn()) {
    return UnauthenticatedBox();
  } else {
    return BidDialog();
  }
}

class BidDialog extends StatefulWidget {
  BidDialog();
  @override
  _BidDialogState createState() => _BidDialogState();
}

class _BidDialogState extends State<BidDialog> {
  double bidAmount;
  int _state = 0;
  final _formKey = GlobalKey<FormState>();

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
                    hintText: highestBid == null
                        ? ""
                        : "Mayor puja: ${highestBid.amount}",
                    labelText: "Puja",
                  ),
                  onChanged: (String newValue) {
                    this.bidAmount = double.parse(newValue);
                  },
                  validator: (value) => value.isEmpty
                      ? "La puja no puede ser vacía"
                      : highestBid != null
                          ? double.parse(value) <= highestBid.amount
                              ? "La puja debe ser mayor a ${highestBid.amount}"
                              : null
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
                            auctionId: auction.auctionId,
                            amount: bidAmount,
                          )
                          .then((value) => Navigator.pop(context));
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
    } else {
      return Container();
    }
  }
}

class DeadlineTimer extends StatelessWidget {
  DeadlineTimer();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
          Duration(
            seconds: 1,
          ),
          (i) => i),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        Duration leftingTime = auction.deadLine.difference(DateTime.now());
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
        viewportFraction: 0.70,
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
