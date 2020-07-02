import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceSignInBox extends StatefulWidget {
  final void Function(FirebaseUser fbUser) parentCallback;
  final Future<FirebaseUser> Function(BuildContext context) signIn;
  final Widget child;

  ServiceSignInBox(
      {@required this.parentCallback,
      @required this.signIn,
      @required this.child});

  @override
  ServiceSignInBoxState createState() => ServiceSignInBoxState();
}

class ServiceSignInBoxState extends State<ServiceSignInBox> {
  static const _ERROR_TEXT =
      'Lo sentimos, se produjo un error, por favor verifica tu conexión a Internet.';

  String state;

  /* ----------------------------------------------------------------------------
    Display Signin button with loading and error indicators
  ---------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    switch (state) {

      // LOADING INDICATOR

      case 'loading':
        return CircularProgressIndicator();
        break;

      // ERROR INDICATOR

      case 'error':
        return Row(children: <Widget>[
          Icon(
            Icons.close,
            color: Colors.red,
          ),
          Flexible(
            child: Text(
              _ERROR_TEXT,
              maxLines: 2,
            ),
          ),
        ]);
        break;

      // LOGIN SCREEN

      default:
        return GestureDetector(
          onTap: () async {
            widget.signIn(context).catchError((error) {
              setState(() {
                this.state = 'error';
              });
            }).then((fbUser) {
              widget.parentCallback(fbUser);
            });

            setState(() {
              this.state = 'loading';
            });
          },
          child: widget.child,
        );
    }
  }
}
