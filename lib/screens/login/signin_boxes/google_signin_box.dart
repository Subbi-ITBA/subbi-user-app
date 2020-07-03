import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subbi/screens/login/signin_boxes/service_signin_box.dart';

class GoogleSignInBox extends StatelessWidget {
  static const _AUTH_SCOPES = [
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/userinfo.profile'
  ];

  final void Function(FirebaseUser fbUser) parentCallback;

  const GoogleSignInBox({Key key, this.parentCallback})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return ServiceSignInBox(
      child: Container(
        height: 40,
        width: 40 * 4.5,
        color: Color(0xFF4285f4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.asset('assets/google_signin.png'),
          Text('Sign in with Google',
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                  ))
        ]),
      ),
      signIn: (context) async {
        // Get credentials

        GoogleSignInAccount googleUser;
        try {
          googleUser = await GoogleSignIn(
            scopes: _AUTH_SCOPES,
          ).signIn();
        } catch (e) {
          print(e.toString());
        }

        // Create FirebaseAuth user

        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: (await googleUser.authentication).accessToken,
          idToken: (await googleUser.authentication).idToken,
        );

        return (await FirebaseAuth.instance.signInWithCredential(credential))
            .user;
      },
      parentCallback: parentCallback,
    );
  }
}

/*
Google -> Exists: Main screen
       -> Not exists: Sign up screen

Email -> Exists: Main screen
      -> Not exists: Sign up screen
      -> Wrong auth: Fail screen
*/
