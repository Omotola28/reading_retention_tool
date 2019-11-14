import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class UserAuth {

  static final auth = FirebaseAuth.instance;
  static FirebaseUser loggedUser;

  static Future<FirebaseUser> getCurrentUser() async{
    try {
      final user = await auth.currentUser();
      if (user != null){
        loggedUser = user;
        //print("Result $loggedUser");
      }
    }
    catch (e) {
      print("Error $e");
    }
    return loggedUser;
  }

  static Future registerUser(String email, String password) async{

    final registerUser = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return registerUser;

  }

  Future signInUser(String email, String password) async{

    final signInUser = await auth.signInWithEmailAndPassword(email: email, password: password);
    return signInUser;
  }
}

/*
class UserRegistrationAuth {



}

class UserSignInAuth{



}*/
