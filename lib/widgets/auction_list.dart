import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/crossShrinkedListView.dart';

class AuctionList extends StatefulWidget {
  final String type;
  AuctionList({this.type});
  @override
  _AuctionListState createState() => _AuctionListState();
}

class _AuctionListState extends State<AuctionList> {

  List<Auction> auctions = [

    Auction(
      title: "Hatsune Miku figure",
      imageURL:
          "https://images-na.ssl-images-amazon.com/images/I/41MpMzeyfaL._AC_SY400_.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    ),

    Auction(
      title:
          "Batman 181 - Poison Ivy - Con grapas - Primera edición - (1966/1966)",
      imageURL:
          "https://assets.catawiki.nl/assets/2020/5/14/5/f/a/5fa78646-70c7-4a12-b4fb-25ec43d71fea.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    ),

    Auction(
      title: "14 quilates Oro - Anillo - 0.79 ct Diamante",
      imageURL:
          "https://assets.catawiki.nl/assets/2020/5/14/a/9/c/a9caba4a-eb7d-4bdd-b796-885da9bc0de2.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    )

  ];

  List<Auction> active_auctions = [

    Auction(
      title:
          "18 quilates Oro blanco - Anillo - 0.25 ct Esmeralda - Diamantes",
      imageURL:
          "https://assets.catawiki.nl/assets/2020/5/12/f/5/9/f5900e98-9db0-4649-a91b-c7e40d367cf0.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    ),

    Auction(
      title: "18 quilates Oro blanco - Anillo - 3.03 ct Zafiro - Diamantes",
      imageURL:
          "https://assets.catawiki.nl/assets/2020/5/9/5/6/a/56a681b2-3cfb-4797-8fef-dad1491db191.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    ),

    Auction(
      title:
          "14 quilates Oro blanco - Anillo - 1.00 ct Turmalina - Diamantes",
      imageURL:
          "https://assets.catawiki.nl/assets/2020/5/10/b/c/8/bc861d6d-50f7-40b5-a7e7-ded2cc01f98a.jpg",
      deadLine: DateTime.now().add(new Duration(days: 3)),
      ownerUid: "123",
      initialPrice: null,
      category: null,
      description: null,
      quantity: null
    )

  ];

  @override
  Widget build(BuildContext context) {
    return CrossShrinkedListView(
      alignment: Axis.horizontal,
      itemCount: auctions.length,
      itemBuilder: (int index) {
        return AuctionCard(
            auction: widget.type == "active"
                ? this.active_auctions[index]
                : this.auctions[index]);
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
      height: 265,
      width: 195,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              Image.network(this.auction.imageURL, height: 147),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 0, 3),
                child: Text(
                  this.auction.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ),
                  
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Text(this.auction.getBids() == null
                    ? "Sin apuestas"
                    : "Highest Bid: ${this.auction.getHighestBid().amount}"
                )
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1), (i) => i),
                  builder: (BuildContext context,
                      AsyncSnapshot<int> snapshot) {
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
                  }
                )
              )

            ],
          ),
        ),
      )
    );

  }
}
