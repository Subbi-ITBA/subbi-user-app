import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/screens/login/signin_screen.dart';
import 'package:subbi/screens/login/signup_screen.dart';

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

        home: SigninScreen()

      )
    );

  }

}