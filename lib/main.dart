import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/screens/loading_screen.dart';
import 'package:subbi/screens/main_screen.dart';
import 'package:subbi/screens/tabs/home_screen.dart';
import 'package:subbi/screens/tabs/profile_screen.dart';
import 'package:subbi/screens/login/signin_screen.dart';
import 'package:subbi/screens/login/signup_screen.dart';
import 'package:subbi/screens/tabs/add_auction_screen.dart';
import 'package:subbi/screens/tabs/chat_screen.dart';
import 'package:subbi/screens/tabs/own_auctions_screen.dart';
import 'package:subbi/screens/tabs/auction_screen.dart';
import 'package:subbi/screens/tabs/category_auctions_screen.dart';
import 'package:subbi/screens/tabs/auction_list_by_sort.dart';
import 'apis/remote_config_api.dart';
import 'apis/server_api.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>.value(
        key: GlobalKey(),
        value: user,
        child: MaterialApp(
          onGenerateRoute: (settings){
            final Map arg = settings.arguments;
            if(settings.name == AuctionListBySortScreen.route){
              return MaterialPageRoute(
                builder: (context){
                  return AuctionListBySortScreen(
                    sort: arg['sort'],
                    title: arg['title']
                  );
                }
              );
            }
            assert(false, 'Need to implement ${settings.name}');
            return null;
            },
            routes: {
              "/home": (context) => HomeScreen(),
              "/profile": (context) => ProfileScreen(),
              "/add_auction": (context) => AddAuctionScreen(),
              "/own_auctions": (context) => OwnAuctionsScreen(),
              "/chat": (context) => ChatScreen(),
              "/auction": (context) => AuctionScreen(),
              "/signin": (context) => SigninScreen(),
              "/signup": (context) => SignupScreen(),
              "/category_auctions": (context) => CategoryAuctionsScreen(),
            },
            theme: ThemeData(
                backgroundColor: Colors.grey[200],
                primarySwatch: Colors.deepPurple,
                textTheme: Theme.of(context).textTheme.copyWith(
                    headline6: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.deepPurple)),
                buttonTheme: Theme.of(context).buttonTheme.copyWith(
                    buttonColor: Colors.deepPurple,
                    textTheme: ButtonTextTheme.primary),
                tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    labelStyle: Theme.of(context).textTheme.overline,
                    unselectedLabelStyle: Theme.of(context).textTheme.overline,
                    labelPadding: EdgeInsets.all(0))),
            home: FutureBuilder(
                future: loadApp(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return MainScreen();

                    default:
                      return LoadingScreen();
                  }
                })));
  }

  /* ----------------------------------------------------------------------------
    Load data that is needed before app start
  ---------------------------------------------------------------------------- */

  Future<void> loadApp(BuildContext context) async {
    user.loadCurrentUser();

    ServerApi.host = '192.168.0.100';
    ServerApi.port = 3000;

    await RemoteConfigApi.instance().initialize();
  }
}
