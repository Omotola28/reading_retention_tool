import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';



class UserAuth {

  static final auth = FirebaseAuth.instance;
  static FirebaseUser loggedUser;
  static final userRef = Firestore.instance.collection('users');
  static User currentUser;

  static Future<FirebaseUser> getCurrentUser() async {
    try {
      final user = await auth.currentUser();
      if (user != null) {
        loggedUser = user;
      }
    }
    catch (e) {
      print("Error $e");
    }
    return loggedUser;
  }

  //TODO: Register new user using the same attributes as googlecreateuser
  //TODO: Check if user exsist is working
  //TODO: Create a test page to tick things you are testing
  //TODO: Create scenario for users
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
        "photoUrl": '',
        "timeStamp": DateTime.now()
      }).catchError((e) => print(e));

      doc = await userRef.document(registeredUser.user.uid).get();
    }

    return  User.fromDocument(doc);
  }

  static Future<User> createUserWithGoogle() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();

    if (!doc.exists) {
      userRef.document(user.id).setData({
        "id": user.id,
        "email": user.email,
        "username": user.email.substring(0, 5),
        "displayname": user.displayName,
        "photoUrl": user.photoUrl,
        "timeStamp": DateTime.now()
      }).catchError((e) => print(e));

      doc = await userRef.document(user.id).get();
    }

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

}
