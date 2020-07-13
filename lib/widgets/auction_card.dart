import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/auction/bid.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/user.dart';
import 'package:provider/provider.dart';
import 'package:subbi/widgets/mercadopago_dialog.dart';

Auction globalAuction;

class AuctionCard extends StatelessWidget {
  final Auction auction;

  AuctionCard({this.auction});

  @override
  Widget build(BuildContext context) {
    globalAuction = this.auction;
    return Container(
        height: 265,
        width: 195,
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/auction',
                arguments: {
                  'auction': globalAuction,
                },
              );
            },
            child: Card(
                elevation: 2,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FutureBuilder<List<Bid>>(
                        future: globalAuction.getLatestBids(0, 1),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            var bid = snap.data.last;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Image.network(
                                  'https://subbi.herokuapp.com/photo/' +
                                      globalAuction.photosIds[0].toString() +
                                      '.jpg',
                                  height: 147,
                                )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 3),
                                  child: Text(
                                    globalAuction.title,
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
                                        bid, globalAuction.auctionId)),
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
                                      Duration leftingTime = globalAuction
                                          .deadLine
                                          .difference(DateTime.now());
                                      return _buildTimer(leftingTime);
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

  Widget _buildTimer(Duration leftingTime) {
    String text;
    if (leftingTime.inSeconds <= 0) {
      text = "CERRADA";
    } else {
      text =
          "Cierra en ${leftingTime.inDays}d ${leftingTime.inHours.remainder(24)}h ${leftingTime.inMinutes.remainder(60)}m ${(leftingTime.inSeconds.remainder(60))}s";
    }
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ignore: must_be_immutable
class HighestBidText extends StatefulWidget {
  final Bid initialBid;
  final int aucID;
  HighestBidText(this.initialBid, this.aucID);

  @override
  _HighestBidTextState createState() => _HighestBidTextState(initialBid.amount);
}

class _HighestBidTextState extends State<HighestBidText> {
  _HighestBidTextState(this.currHighestBid);
  double currHighestBid;
  @override
  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  void initializeSocket() {
    ServerApi.instance().emitSocketEvent('subscribe', widget.aucID);

    ServerApi.instance().onSocketEvent(
      'bidPublished',
      (data) {
        if (this.mounted) {
          if (data['auc_id'] == widget.aucID) {
            setState(() {
              currHighestBid = double.parse(data["amount"]);
            });
          }
        }
      },
    );
    ServerApi.instance().onSocketEvent(
      'auctionClosed',
      (data) {
        if (data['auc_id'] == globalAuction.auctionId) {
          var user = Provider.of<User>(context);
          if (user.isSignedIn() && user.getUID() == data['user']) {
            globalAuction.state = "CLOSED";
            MercadoPagoDialog.showWinnerDialog(
                context, currHighestBid, globalAuction, data['preference_id']);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(currHighestBid == -1
        ? "Sin pujas"
        : "Puja actual: " + currHighestBid.toString());
  }
}
