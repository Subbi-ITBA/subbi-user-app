import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/login/signup_screen.dart';

class SigninScreen extends StatelessWidget{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: Card(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo.png', height: 70, width: 70),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GoogleSignInBox(signInButtonHeight: 40),
                  ),

                ]
              ),
            ),
          ),
        ),
      ),

    );

  }


  void signUp(){

  }


}




class GoogleSignInBox extends StatefulWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final double signInButtonHeight;

  GoogleSignInBox({@required this.signInButtonHeight});

  @override
  GoogleSignInBoxState createState() => GoogleSignInBoxState();

}



class GoogleSignInBoxState extends State<GoogleSignInBox> {


  /* ----------------------------------------------------------------------------
                               STATIC VALUES
  ---------------------------------------------------------------------------- */

  static const _BUTTON_COLOR = Color(0xFF4285f4);
  static const _BUTTON_LOGO_ASSET = 'assets/google_signin.png';
  static const _ERROR_TEXT = 'Lo sentimos, se produjo un error, por favor verifica tu conexión a Internet.';

  static const _AUTH_SCOPES = ['https://www.googleapis.com/auth/user.birthday.read', 'https://www.googleapis.com/auth/userinfo.profile'];


  /* ----------------------------------------------------------------------------
                                   STATE
  ---------------------------------------------------------------------------- */

  String state;


  /* ----------------------------------------------------------------------------
    Display Signin button with loading and error indicators
  ---------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {

    switch(state){
      
      // LOADING INDICATOR

      case 'loading':
        return CircularProgressIndicator();
        break;


      // ERROR INDICATOR

      case 'error':
        return Row(children: <Widget>[
          Icon(Icons.close, color: Colors.red),
          Flexible(child: Text(_ERROR_TEXT, maxLines: 2,)),
        ]);
        break;


      // LOGIN SCREEN

      default:
        return GestureDetector(
          onTap: (){

            signIn(context).catchError((error){
              setState(() { this.state='error'; });
            });

            setState(() { this.state='loading'; });
            
          },
          child: Container(
            height: widget.signInButtonHeight,
            width: widget.signInButtonHeight*4.5,
            color: _BUTTON_COLOR,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Image.asset(_BUTTON_LOGO_ASSET),
                Text('Sign in with Google', style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white))
              ]
            ),
          )
        );

    }
  }


  /* ----------------------------------------------------------------------------
    Perform Google Signin and store credentials. If user exists, return to main
    app, else go to PersonalityAssesment.
  ---------------------------------------------------------------------------- */

  Future<void> signIn(context) async {

    // Get credentials

    GoogleSignInAccount googleUser;
    try{
      googleUser = await GoogleSignIn(scopes: _AUTH_SCOPES).signIn();
    }catch(e){
      print(e.toString());
    }


    // Create FirebaseAuth user

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: (await googleUser.authentication).accessToken,
      idToken: (await googleUser.authentication).idToken,
    );
    FirebaseUser fbUser = (await widget._auth.signInWithCredential(credential)).user;


    // Initialize user

    User user = Provider.of<User>(context, listen: false);
    user.initialize(fbUser);


    // If user is new, go to sign up screen

    if(true || !(await user.exists())){

      // This creates a document for the user. It is needed because the accounts authentication processes use it.
      await user.signUp();

      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) => SignupScreen())
      );
      
    }

    Navigator.pop(context, fbUser);

  }


}