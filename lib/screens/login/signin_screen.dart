import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/login/signin_boxes/email_signin_box.dart';
import 'package:subbi/screens/login/signin_boxes/google_signin_box.dart';

BuildContext screenContext;

class SigninScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenContext = context;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor, elevation: 0, iconTheme: IconThemeData(color: Colors.deepPurple),),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 500,
            width: 300,
            child: Card(
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 70,
                          width: 70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Bienvenido',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EmailSignInBox(
                          parentCallback: signIn,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GoogleSignInBox(
                          parentCallback: signIn,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(FirebaseUser fbUser) async {
    // Initialize user
    User user = Provider.of<User>(
      screenContext,
      listen: false,
    );
    user.initialize(fbUser);

    // If user is new, go to sign up screen
    bool exists = await user.signIn();
    if (!exists) {
      await Navigator.pushNamed(screenContext, '/signup');
    }

    Navigator.of(screenContext).pop();
  }
}
