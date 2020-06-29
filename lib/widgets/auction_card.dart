import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';

class AuctionCard extends StatelessWidget {
  final Auction auction;
  AuctionCard({this.auction});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 265,
        width: 195,
        child: GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, '/auction',
                  arguments: {'auction': this.auction})
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Image.network(this.auction.imageURL[0], height: 147)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 3),
                        child: Text(
                          this.auction.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(this.auction.getBids() == null
                            ? "Sin apuestas"
                            : "Highest Bid: ${this.auction.getHighestBid().amount}")),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: StreamBuilder(
                            stream:
                            Stream.periodic(Duration(seconds: 1), (i) => i),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
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
                                    fontWeight: FontWeight.bold),
                              );
                            }))
                  ],
                ),
              ),
            )));
  }
}
