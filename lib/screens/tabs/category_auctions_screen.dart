import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/auction_card.dart';

class CategoryAuctionsScreen extends StatefulWidget {
  static const AUCTION_PAGE_SIZE = 20;
  static const String route = "/category_auctions";
  final String category;

  const CategoryAuctionsScreen({Key key, @required this.category})
      : super(key: key);

  @override
  _CategoryAuctionsScreenState createState() => _CategoryAuctionsScreenState();
}

class _CategoryAuctionsScreenState extends State<CategoryAuctionsScreen> {
  ScrollController _scrollController;
  AuctionIterator _auctionIterator;

  Map data = {};
  String dropDownVal = 'Novedad';

  @override
  void initState() {
    super.initState();
    print(widget.category);
    _auctionIterator = getAuctionIterator();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        // if end of the screen is reached show more auctions

        setState(() {
          _auctionIterator.moveNext();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<Auction>>(
        future: _auctionIterator.current,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var auctions = snap.data;
          if (auctions.isNotEmpty) {
            return ListView(
              controller: _scrollController,
              children: <Widget>[
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[400],
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${auctions.length} resultados'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Ordernar por: ',
                            ),
                            DropdownButton<String>(
                              value: dropDownVal,
                              onChanged: (String newVal) {
                                setState(() {
                                  dropDownVal = newVal;
                                  _auctionIterator = getAuctionIterator();
                                });
                              },
                              items: <String>[
                                'Novedad',
                                'Popular',
                                'Finalizando'
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: auctions.length,
                  itemBuilder: (context, i) {
                    return AuctionCard(auction: auctions.elementAt(i));
                  },
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Todavia no hay subastas de esta categoria.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  AuctionIterator getAuctionIterator() {
    switch (dropDownVal) {
      case "Novedad":
        return Auction.getLatestAuctions(
          category: widget.category,
          pageSize: CategoryAuctionsScreen.AUCTION_PAGE_SIZE,
        );
      case "Popular":
        return Auction.getPopularAuctions(
          category: widget.category,
          pageSize: CategoryAuctionsScreen.AUCTION_PAGE_SIZE,
        );
      case "Finalizando":
        return Auction.getEndingAuctions(
          category: widget.category,
          pageSize: CategoryAuctionsScreen.AUCTION_PAGE_SIZE,
        );
      default:
        throw ArgumentError("Unsupported sorting method");
    }
  }
}
