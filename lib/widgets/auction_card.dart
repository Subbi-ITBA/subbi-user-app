import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/auction/bid.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AuctionCard extends StatelessWidget {
  final Auction auction;

  AuctionCard({this.auction});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 265,
        width: 195,
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/auction',
                arguments: {
                  'auction': this.auction,
                },
              );
            },
            child: Card(
                elevation: 2,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FutureBuilder<List<Bid>>(
                        future: auction.getLatestBids(0, 1),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            var bids = snap.data;
                            print(bids);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Image.network(
                                  'https://subbi.herokuapp.com/photo/' +
                                      this.auction.photosIds[0].toString() +
                                      '.jpg',
                                  height: 147,
                                )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 3),
                                  child: Text(
                                    this.auction.title,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: HighestBidText(
                                        bids.isEmpty ? -1 : bids.last.amount,
                                        auction.auctionId)),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: StreamBuilder(
                                    stream: Stream.periodic(
                                        Duration(
                                          seconds: 1,
                                        ),
                                        (i) => i),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<int> snapshot,
                                    ) {
                                      Duration leftingTime = this
                                          .auction
                                          .deadLine
                                          .difference(DateTime.now());
                                      String sDuration =
                                          "Cierra en ${leftingTime.inDays}d ${leftingTime.inHours.remainder(24)}h ${leftingTime.inMinutes.remainder(60)}m ${(leftingTime.inSeconds.remainder(60))}s";

                                      return Text(
                                        sDuration,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })))));
  }
}

class HighestBidText extends StatefulWidget {
  double currHighestBid;
  int aucID;
  HighestBidText(this.currHighestBid, this.aucID);

  @override
  _HighestBidTextState createState() => _HighestBidTextState();
}

class _HighestBidTextState extends State<HighestBidText> {
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
    print('initializing socket IO');

    socket = IO.io('http://subbi.herokuapp.com/auction', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.emit('subscribe', widget.aucID);
    socket.on('connect', (_) {
      print('connected');
    });
    socket.on('bidPublished', (data) {
      if (this.mounted) {
        setState(() {
          widget.currHighestBid = double.parse(data["amount"]);
        });
      }
    });

    print('end init');
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.currHighestBid == -1
        ? "Sin pujas"
        : "Puja actual: " + widget.currHighestBid.toString());
  }
}
