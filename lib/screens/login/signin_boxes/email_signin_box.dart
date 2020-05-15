import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EmailSignInBox extends StatefulWidget {

  static String emailRegex = "(?:[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])";

  final void Function(FirebaseUser fbUser) parentCallback;

  const EmailSignInBox({Key key, this.parentCallback}) : super(key: key);

  @override
  _EmailSignInBoxState createState() => _EmailSignInBoxState();

}


class _EmailSignInBoxState extends State<EmailSignInBox> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> passKey = GlobalKey<FormFieldState>();

  String authState;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: emailKey,

              decoration: const InputDecoration(
                hintText: 'Email',
              ),

              validator: (String email){
                if(email==null || email=="")
                  return 'Campo requerido';
                if(! RegExp(EmailSignInBox.emailRegex).hasMatch(email))
                  return 'Email inválido';

                return null;
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: passKey,

              decoration: const InputDecoration(
                hintText: 'Password',
              ),

              validator: (String pass){
                if(pass==null || pass=='')
                  return 'Campo requerido';
                if(pass.length < 8)
                  return 'Debe tener más de 8 caracteres';
                
                return null;
              },

              obscureText: true,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlineButton(
                  child: Text('Iniciar sesión'),
                  onPressed: () => signIn()
                ),

                OutlineButton(
                  child: Text('Crear cuenta'),
                  onPressed: () => signUp()
                )
              ]
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: builAuthStateIndicator(authState)
          )

        ],
      )
    );

  }


  void signIn() async{

    setState(() {
      authState = 'loading';
    });

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailKey.currentState.value,
      password: passKey.currentState.value
    )
    
    .then((auth){
      widget.parentCallback(auth.user);
    })
    
    .catchError((error){

      PlatformException exception = error;

      setState(() {
        switch(exception.code){

          case 'ERROR_INVALID_EMAIL':
            authState = 'Email inválido';
            break;

          case 'ERROR_WRONG_PASSWORD':
            authState = 'Contraseña erronea';
            break;

          case 'ERROR_USER_NOT_FOUND':
            authState = 'Email no encontrado';
            break;

          case 'ERROR_USER_DISABLED':
            authState = 'Usuario deshabilitado';
            break;

          default:
            authState = 'Ha surgido un error';
            break;
            
        }
      });
    });

  }


  void signUp() async {

      setState(() {
        authState = 'loading';
      });

      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailKey.currentState.value,
        password: passKey.currentState.value
      )

      .then((auth){
        auth.user.sendEmailVerification();        
        widget.parentCallback(auth.user);
      })
      
      .catchError((error){

        PlatformException exception = error;

        setState(() {
          switch(exception.code){

            case 'ERROR_WEAK_PASSWORD':
              authState = 'Contraseña débil';
              break;

            case 'ERROR_INVALID_EMAIL':
              authState = 'Email inválido';
              break;

            case 'ERROR_EMAIL_ALREADY_IN_USE':
              authState = 'Usuario ya registrado';
              break;

            default:
              authState = 'Ha surgido un error';
              break;
              
          }
        });
    });

  }


  builAuthStateIndicator(String authState) {

    if(authState==null || authState=='')
      return Container();

    if(authState=='loading')
      return CircularProgressIndicator();

    return Text(authState);

  }

}