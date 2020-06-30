import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/cross_shrinked_listview.dart';
import 'package:subbi/widgets/auction_card.dart';

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
        imageURL: [
          "https://resize.cdn.otakumode.com/exq/65/650.800/shop/product/b3006d572614431d88b8c95c28a6c92d.jpg",
          "https://resize.cdn.otakumode.com/ex/350.430/shop/product/7a70daa30d714f5b874cc1272db3c06b.jpg.webp",
          "https://resize.cdn.otakumode.com/ex/350.430/shop/product/80f559e3fff645c8a1f08dc35d5cea6c.jpg.webp",
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: "*No Reserve Price*\n 100% Natural White Diamond (Untreated)\n Ideally suited as an investment, collector's item, or to set in jewellery.\nThis diamond includes a full ALGT Laboratory certificate (Belgium).\nPlease see attached report for specifics.\nALGT Report Number: 23112987*\nCOVID-19 Shipping Disclaimer:\nWe follow all safety measures taken by each individual country regarding postal delivery, so far no delays have occurred.\nAll orders are packed & shipped with great care and delivered by an Express Courier Service.are insured for Full Value and have accurate Online Tracking, striving for a 48-hour delivery time within the EU. (All EU shipments are Exempt from import Duties.)",
        quantity: null),
    Auction(
        title:
            "Batman 181 - Poison Ivy - Con grapas - Primera edición - (1966/1966)",
        imageURL: [
          "https://assets.catawiki.nl/assets/2020/5/14/5/f/a/5fa78646-70c7-4a12-b4fb-25ec43d71fea.jpg",
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: null,
        quantity: null),
    Auction(
        title: "14 quilates Oro - Anillo - 0.79 ct Diamante",
        imageURL: [
          "https://assets.catawiki.nl/assets/2020/5/14/a/9/c/a9caba4a-eb7d-4bdd-b796-885da9bc0de2.jpg"
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: null,
        quantity: null)
  ];

  List<Auction> active_auctions = [
    Auction(
        title:
            "18 quilates Oro blanco - Anillo - 0.25 ct Esmeralda - Diamantes",
        imageURL: [
          "https://assets.catawiki.nl/assets/2020/5/12/f/5/9/f5900e98-9db0-4649-a91b-c7e40d367cf0.jpg"
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: null,
        quantity: null),
    Auction(
        title: "18 quilates Oro blanco - Anillo - 3.03 ct Zafiro - Diamantes",
        imageURL: [
          "https://assets.catawiki.nl/assets/2020/5/9/5/6/a/56a681b2-3cfb-4797-8fef-dad1491db191.jpg"
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: null,
        quantity: null),
    Auction(
        title:
            "14 quilates Oro blanco - Anillo - 1.00 ct Turmalina - Diamantes",
        imageURL: [
          "https://assets.catawiki.nl/assets/2020/5/10/b/c/8/bc861d6d-50f7-40b5-a7e7-ded2cc01f98a.jpg"
        ].toList(),
        deadLine: DateTime.now().add(new Duration(days: 3)),
        ownerUid: "123",
        initialPrice: null,
        category: null,
        description: null,
        quantity: null)
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
<<<<<<< HEAD

=======
>>>>>>> f1877410c72aa98bda612fd4e24e6dd434280143
