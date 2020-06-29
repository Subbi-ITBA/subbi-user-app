import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/auction_card.dart';

class CategoryAuctionsScreen extends StatefulWidget {
  @override
  _CategoryAuctionsScreenState createState() => _CategoryAuctionsScreenState();
}

class _CategoryAuctionsScreenState extends State<CategoryAuctionsScreen> {
  Map data = {};
  ScrollController _scrollController = ScrollController();
  String dropDownVal = 'Novedad';

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
        description: null,
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
        quantity: null),
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

  ];
  Auction aux = Auction(
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
      quantity: null);

  @override
  void initState(){
    super.initState();
    //TODO FETCH AUCTIONS 20
    print('scroll to be init');
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // if end of the screen is reached show more auctions if the are more
        print('reached end');
        setState(() {
          auctions.add(aux);
        });
        //TODO SHOW MORE 20 AUCTIONS
      }
    });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['category']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 25,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[400],
                    width: 1
                  )
                )
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5,0,5,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${auctions.length} resultados'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Ordernar por: '),
                        DropdownButton<String>(
                          value: dropDownVal,
                          onChanged: (String newVal){
                            setState(() {
                              dropDownVal = newVal;
                            });
                          },
                          items: <String>['Novedad','Popular']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                ],),
              )
            ),
            // TODO Listar auctions
            GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,),
              itemCount: auctions.length,
              itemBuilder: (context,i){
                return AuctionCard(auction: auctions.elementAt(i));
              }
            ),
          ],
        ),
      )
    );
  }
}
