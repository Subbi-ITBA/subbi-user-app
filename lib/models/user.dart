import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/profile/profile.dart';

class User extends ChangeNotifier {
  /* ------------------------------ STATIC PROPERTIES ------------------------------ */

  /* ------------------------------ INSTANCE PROPERTIES ------------------------------ */

  FirebaseUser fbUser;
  PersonalInformation personalInfo;
  Profile profile;

  /* ------------------------------ INITIALIZATION METHODS ------------------------------ */

  /* ----------------------------------------------------------------------------
    Sets FirebaseUser and Firestore reference
  ---------------------------------------------------------------------------- */

  void initialize(FirebaseUser fbUser) {
    this.fbUser = fbUser;
  }

  void notify() {
    notifyListeners();
  }

  /* ------------------------------ STORAGE METHODS ------------------------------ */

  bool isSignedIn() => fbUser != null;

  Future<void> loadCurrentUser() async {
    this.fbUser = await FirebaseAuth.instance.currentUser();
    signIn();
  }

  /* ----------------------------------------------------------------------------
    Send auth token and check if user exists
  ---------------------------------------------------------------------------- */

  Future<bool> signIn() async {
    return await ServerApi.instance().signIn(userToken: await getToken());
  }

  /* ----------------------------------------------------------------------------
    Send personal data to the server
  ---------------------------------------------------------------------------- */

  Future<void> signUp() async {
    await ServerApi.instance().signUp(
        name: personalInfo.name,
        surname: personalInfo.surname,
        docId: personalInfo.docId,
        phone: personalInfo.phone,
        docType: personalInfo.docType,
        phoneType: personalInfo.phoneType,
        country: personalInfo.country,
        state: personalInfo.state,
        city: personalInfo.city,
        address: personalInfo.address,
        addressNumber: personalInfo.addressNumber,
        zip: personalInfo.zip);
  }

  /* ----------------------------------------------------------------------------
    Delete user from server
  ---------------------------------------------------------------------------- */

  Future<void> delete() async {
    await ServerApi.instance().deleteAccount(uid: fbUser.uid);
  }

  /* ----------------------------------------------------------------------------
    Returns the auth token of the user
  ---------------------------------------------------------------------------- */

  Future<String> getToken() async {
    return (await fbUser.getIdToken()).token;
  }

  /* ----------------------------------------------------------------------------
    Get the UID
  ---------------------------------------------------------------------------- */

  String getUID() {
    return fbUser.uid;
  }
}

class PersonalInformation {
  String name, surname, docId, phone;
  DocType docType;
  PhoneType phoneType;
  String country, state, city, address, addressNumber, zip;
}
