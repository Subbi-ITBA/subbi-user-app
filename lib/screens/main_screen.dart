import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subbi/screens/tabs/add_auction_screen.dart';
import 'package:subbi/screens/tabs/home_screen.dart';
import 'package:subbi/screens/tabs/own_auctions_screen.dart';

class MainScreen extends StatelessWidget {
  static const HOME_TAB = 0;
  static const OWN_AUCTIONS = 1;
  static const ADD_AUCTION = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.gavel),
              ),
              Tab(
                icon: Icon(Icons.add),
              ),
              // Tab(
              //   icon: Icon(Icons.person),
              // )
            ],
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            OwnAuctionsScreen(),
            AddAuctionScreen(),
          ],
        ),
      ),
    );
  }
}
