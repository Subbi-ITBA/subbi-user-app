import 'package:flutter/material.dart';
import 'login/signin_screen.dart';

class UnauthenticatedBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Debes iniciar sesión para ver esta página'),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text('Iniciar Sesión'),
            onPressed: (){

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SigninScreen()
                )
              );

            },
          ),
        )

      ],
    );
  }

}