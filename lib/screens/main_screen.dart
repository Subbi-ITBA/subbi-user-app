import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subbi/screens/tabs/chat_screen.dart';
import 'package:subbi/screens/tabs/home_screen.dart';
import 'package:subbi/screens/tabs/own_auctions_screen.dart';

class MainScreen extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home)
              ),
              Tab(
                icon: Icon(Icons.chat),
              ),
              Tab(
                icon: Icon(Icons.shopping_cart)
              ),
              Tab(
                icon: Icon(Icons.person),
              )
            ],
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.grey,
          )
        ),

        body: TabBarView(
          children:[

            HomeScreen(),

            ChatScreen(),
            
            OwnAuctionsScreen(),

            Container(),

          ],
        ) 
      ),
    );
  }

}