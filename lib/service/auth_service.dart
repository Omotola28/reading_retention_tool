import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'navigation_service.dart';
import 'package:reading_retention_tool/utils/locator.dart';



class UserAuth {

  static final auth = FirebaseAuth.instance;
  static FirebaseUser loggedUser;
  static final userRef = Firestore.instance.collection('users');
  static var currentUser;
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static final NavigationService _navigationService = locator<NavigationService>();


  static Future<FirebaseUser> getCurrentUser() async {
    var user;

    try {
      user = await auth.currentUser();

      if (user != null) {
        currentUser = user;
      }
      else{
        currentUser = googleSignIn.currentUser;
      }
    }
    catch (e) {
      print("Error $e");
    }

    return currentUser;
  }

  static Future<User> registerUser(String email, String password, String displayName) async {

    final registeredUser = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    DocumentSnapshot doc = await userRef.document(registeredUser.user.uid).get();

    if(!doc.exists){
      userRef.document(registeredUser.user.uid).setData({
        "id": registeredUser.user.uid,
        "email": registeredUser.user.email,
        "username": displayName,
        "displayname": displayName,
        "photoUrl": 'https://images.unsplash.com/photo-1569414753782-7b8cef3ad2e8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
        "timeStamp": DateTime.now()
      }).catchError((e) => print(e));

      doc = await userRef.document(registeredUser.user.uid).get();
    }

    return  User.fromDocument(doc);
  }

  static Future<User> createUserWithGoogle() async {
      final GoogleSignInAccount userAccount =  googleSignIn.currentUser;

      final GoogleSignInAuthentication googleSignInAuthentication = await userAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;


      userRef.document(user.uid).setData({
        "id": user.uid,
        "email": user.email,
        "username": user.email.substring(0, 5),
        "displayname": user.displayName,
        "photoUrl": user.photoUrl,
        "timeStamp": DateTime.now()
      }).catchError((e) => print(e));

      DocumentSnapshot doc = await userRef.document(user.uid).get();

      return User.fromDocument(doc);

  }


  static Future<User> signInUser(String email, String password) async {

    final signInUser = await auth.signInWithEmailAndPassword(
        email: email, password: password);


    DocumentSnapshot doc = await userRef.document(signInUser.user.uid).get();

    if(doc.exists){
      doc = await userRef.document(signInUser.user.uid).get();
      return User.fromDocument(doc);
    }
  }

  static Future<User> googleLogIn() async {
    GoogleSignInAccount googleSignInAcct = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAcct.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;


    userRef.document(user.uid).setData({
      "id": user.uid,
      "email": user.email,
      "username": user.email.substring(0, 5),
      "displayname": user.displayName,
      "photoUrl": user.photoUrl,
      "timeStamp": DateTime.now()
    }).catchError((e) => print(e));

    DocumentSnapshot doc = await userRef.document(user.uid).get();

    return User.fromDocument(doc);

  }

  static Future<bool> isFirebaseUserLoggedIn() async{
    var user = await FirebaseAuth.instance.currentUser();
    return user != null;
  }


}
