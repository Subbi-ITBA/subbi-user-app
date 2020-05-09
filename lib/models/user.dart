
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User extends ChangeNotifier{

  /* ------------------------------ STATIC PROPERTIES ------------------------------ */

  static CollectionReference _storePath = Firestore.instance.collection('profiles');


  /* ------------------------------ INSTANCE PROPERTIES ------------------------------ */

  DocumentReference reference;
  FirebaseUser fbUser;



  /* ------------------------------ INITIALIZATION METHODS ------------------------------ */


  /* ----------------------------------------------------------------------------
    Sets FirebaseUser and Firestore reference
  ---------------------------------------------------------------------------- */

  void initialize(FirebaseUser fbUser){
    this.fbUser = fbUser;
    this.reference = _storePath.document(fbUser.email);
  }


  void notify(){ notifyListeners(); }



  /* ------------------------------ FIRESTORE METHODS ------------------------------ */



  /* ----------------------------------------------------------------------------
    Check if user exists on Firebase
  ---------------------------------------------------------------------------- */

  Future<bool> exists() async{
    return (await reference.get()).exists;
  }


  /* ----------------------------------------------------------------------------
    Create a record for the user on Firebase
  ---------------------------------------------------------------------------- */

  Future<void> signUp() async{
    await reference.setData({'creationDate': DateTime.now()});
  }


  /* ----------------------------------------------------------------------------
    Returns the auth token of the user
  ---------------------------------------------------------------------------- */

  Future<String> getToken() async{
    return (await fbUser.getIdToken()).token;
  }

}
