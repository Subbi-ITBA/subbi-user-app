import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/screens/loading_screen.dart';
import 'package:subbi/screens/login/signin_screen.dart';
import 'apis/remote_config_api.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<User>(
      key: GlobalKey(),
      create: (context) => User(),
      child: MaterialApp(

        theme: ThemeData(

          backgroundColor: Colors.grey[200],
          primarySwatch: Colors.deepPurple,

          textTheme: Theme.of(context).textTheme.copyWith(
            title: Theme.of(context).textTheme.title.copyWith(
              color: Colors.deepPurple
            )
          )

        ),

        home: FutureBuilder(
          future: loadApp(context),
          builder: (context, snapshot){

            switch(snapshot.connectionState){
              
              case ConnectionState.done:
                return SigninScreen();

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

    // GlobalKey<FormFieldState> urlKey = GlobalKey<FormFieldState>();
    // GlobalKey<FormFieldState> portKey = GlobalKey<FormFieldState>();

    // Map<String, String> conf = await showDialog(
    //   context: context,
    //   child: AlertDialog(
    //     content: Form(
    //       child: Column(
    //         children: [
    //           TextField(
    //             key: urlKey,
    //             decoration: const InputDecoration(
    //               hintText: 'URL',
    //             ),
    //           ),
    //           TextField(
    //             key: portKey,
    //             decoration: const InputDecoration(
    //               hintText: 'Port',
    //             ),
    //           ),
    //           OutlineButton(
    //             child: Text('Continuar'),
    //             onPressed: (){
    //               Navigator.of(context).pop({
    //                 'url': urlKey.currentState.value,
    //                 'port': urlKey.currentState.value
    //               });
    //             },
    //           )
    //         ]
    //       ),
    //     ),
    //   )
    // );

    // ServerApi.instance().host = 'localhost';//conf['url'];
    // ServerApi.instance().port = 3000;//int.parse(conf['port']);

    // await RemoteConfigApi.instance().initialize();
    
  }

}