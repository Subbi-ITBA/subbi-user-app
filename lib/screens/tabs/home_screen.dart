import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          height: 100,
          child: AppBar(),
        ),

        Expanded(
          child: Center(
            child: Text('Hello'),
          ),
        )

      ]
    );
  }


}