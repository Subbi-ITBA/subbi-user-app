import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/screens/loading_screen.dart';
import 'package:subbi/screens/main_screen.dart';
import 'apis/remote_config_api.dart';
import 'apis/server_api.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final User user = User();

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<User>(
      key: GlobalKey(),
      create: (context) => user,
      child: MaterialApp(

        theme: ThemeData(

          backgroundColor: Colors.grey[200],
          primarySwatch: Colors.deepPurple,

          textTheme: Theme.of(context).textTheme.copyWith(
            title: Theme.of(context).textTheme.title.copyWith(
              color: Colors.deepPurple
            )
          ),

          buttonTheme: Theme.of(context).buttonTheme.copyWith(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary
          ),

          tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
            labelStyle: Theme.of(context).textTheme.overline,
            unselectedLabelStyle: Theme.of(context).textTheme.overline,
            labelPadding: EdgeInsets.all(0)
          )

        ),

        home: FutureBuilder(
          future: loadApp(context),
          builder: (context, snapshot){

            switch(snapshot.connectionState){
              
              case ConnectionState.done:
                return MainScreen();

              default:
                return LoadingScreen();

            }

          } 
          
        )

      )
    );

  }


  /* ----------------------------------------------------------------------------
    Load data that is needed before app start
  ---------------------------------------------------------------------------- */

  Future<void> loadApp(BuildContext context) async{
    
    user.loadCurrentUser();

    ServerApi.host = '192.168.0.100';
    ServerApi.port = 3000;

    await RemoteConfigApi.instance().initialize();
    
  }

}