import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{

  static double _loadingLogoSize = 35;
  static double _loadingCircleSize = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    width: _loadingLogoSize,
                    height: _loadingLogoSize
                  ),
                  SizedBox(
                    child: CircularProgressIndicator(),
                    height: _loadingCircleSize,
                    width: _loadingCircleSize
                  ),
                ]
              )
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Subbi', style: Theme.of(context).textTheme.title,),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Subastas ya', style: Theme.of(context).textTheme.subhead,),
            )

          ],
        ),
      )

    );
  }


}