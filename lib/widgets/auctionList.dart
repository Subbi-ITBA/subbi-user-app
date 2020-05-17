import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AuctionList extends StatefulWidget {
  @override
  _AuctionListState createState() => _AuctionListState();
}

class _AuctionListState extends State<AuctionList> {
  List<Auction> auctions = [
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          minutes: 1,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          days: 1,
          hours: 3,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          days: 1,
          hours: 3,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          days: 1,
          hours: 3,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          hours: 3,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          hours: 3,
        )),
        ownerUid: "1"),
    Auction(
        title: "Hatsune Miku figure",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/71R%2BeXyM9sL._AC_SX425_.jpg",
        deadLine: DateTime.now().add(new Duration(
          hours: 3,
        )),
        ownerUid: "1"),
  ];
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return CrossShrinkedListView(
      alignment: Axis.horizontal,
      itemCount: auctions.length,
      itemBuilder: (int index) {
        return AuctionCard(auction: this.auctions[index]);
      },
    );
  }
}

class AuctionCard extends StatelessWidget {
  final Auction auction;
  AuctionCard({this.auction});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 320,
        width: 200,
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.network(
                  this.auction.imageURL,
                ),
                Text(
                  this.auction.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(this.auction.getBids() == null
                    ? "Sin apuestas"
                    : "Highest Bid: ${this.auction.getHighestBid().amount}"),
                StreamBuilder(
                    stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      Duration leftingTime =
                          this.auction.deadLine.difference(DateTime.now());
                      String sDuration =
                          "Cierra en ${leftingTime.inDays}d ${leftingTime.inHours.remainder(24)}h ${leftingTime.inMinutes.remainder(60)}m ${(leftingTime.inSeconds.remainder(60))}s";

                      return Text(
                        sDuration,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}

class CrossShrinkedListView extends StatelessWidget {
  final int itemCount;
  final Function itemBuilder;
  final Axis alignment;
  final List<Widget> items;

  CrossShrinkedListView(
      {this.itemCount,
      this.itemBuilder,
      this.items,
      this.alignment = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: alignment == Axis.horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    items ?? List<Widget>.generate(itemCount, itemBuilder))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    items ?? List<Widget>.generate(itemCount, itemBuilder)));
  }
}
