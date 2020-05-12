import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';

class HomeScreen extends StatelessWidget{

  User user;
  
  @override
  Widget build(BuildContext context) {

    user = Provider.of<User>(context);

    return Scaffold(
      body: Builder(
        builder: (BuildContext scaffoldContext){
          return Center(
            child: Container(
              height: 200,
              width: 300,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Bienvenido'),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        child: Text('Borrar cuenta'),
                        onPressed: () async{

                          Scaffold.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('Borrando cuenta'))
                          );

                          await user.delete();

                          Scaffold.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('Cuenta borrada'))
                          );

                        },
                      ),
                    )

                  ]
                )
              ),
            ),
         );
        }
      ) 
    );
  }

}