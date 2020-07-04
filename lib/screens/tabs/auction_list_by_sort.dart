import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/widgets/auction_card.dart';

class AuctionListBySortScreen extends StatefulWidget {
  static const AUCTION_PAGE_SIZE = 8;
  static const String route = "/auction_list_by_sort";
  final String sort;
  final String title;

  const AuctionListBySortScreen({
    Key key,
    @required this.sort,
    @required this.title,
  }) : super(key: key);

  @override
  _AuctionListBySortScreenState createState() =>
      _AuctionListBySortScreenState();
}

class _AuctionListBySortScreenState extends State<AuctionListBySortScreen> {
  List<Auction> _loadedAuctions = [];
  AuctionIterator _auctionIterator;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: loadAuctions(),
        builder: (context, snap) {
          return ListView(
            controller: _scrollController,
            children: <Widget>[
              GridView.builder(
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: _loadedAuctions.length,
                itemBuilder: (context, i) {
                  return AuctionCard(auction: _loadedAuctions.elementAt(i));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  AuctionIterator getAuctionIterator() {
    switch (widget.sort) {
      case "popularity":
        return Auction.getPopularAuctions(
          category: null,
          pageSize: AuctionListBySortScreen.AUCTION_PAGE_SIZE,
        );
      case "latest":
        return Auction.getLatestAuctions(
          category: null,
          pageSize: AuctionListBySortScreen.AUCTION_PAGE_SIZE,
        );
      case "deadline":
        return Auction.getEndingAuctions(
          category: null,
          pageSize: AuctionListBySortScreen.AUCTION_PAGE_SIZE,
        );
      default:
        throw ArgumentError("Unsupported sorting method");
    }
  }

  Future<void> loadAuctions() async {
    _loadedAuctions.addAll(await _auctionIterator.current);
  }
}
