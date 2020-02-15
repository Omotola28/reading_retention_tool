import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:flutter/scheduler.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/WaitingToLoginScreen.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'ProgressIndicators.dart';


class WelcomePage extends StatefulWidget {


  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {


  @override
  void initState(){
    super.initState();
    //This function loadGetStartedScreen should be called when this screen shows after 3 secs
    SchedulerBinding.instance.addPostFrameCallback((_) => loadGetStartedScreen());
  }

  void loadGetStartedScreen(){
    Future.delayed(Duration(seconds: 3), () {


      ///Siliently login if the user is a google sign in user
      if(UserAuth.googleSignIn.currentUser != null ){
        UserAuth.googleSignIn.signInSilently(suppressErrors: false)
            .then((account){
          handleSignInWithGoogle(account);
        }).catchError((err){
          print('Sign in failed $err');
        });
      }

      ///Silently login if the user is a firebase user
      if(FirebaseAuth.instance.currentUser() != null ){
        Provider.of<AppData>(context).setCustomSignIn(true);
        handleSilentFirebaseLogin();
      }

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)
        => GetStartedScreen()
        ),
      );

    });
  }

  handleSignInWithGoogle(GoogleSignInAccount account){
    if(account != null){
      var user = UserAuth.createUserWithGoogle();

      user.then((userData){
        Provider.of<AppData>(context).setUserData(userData);
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)
        => HomeScreen()
        ),
      );
    }

  }

  handleSilentFirebaseLogin() async {
    var hasUserLoggedIn = await UserAuth.isFirebaseUserLoggedIn();

    if(hasUserLoggedIn){

      var user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot doc = await Firestore.instance.collection('users').document(user.uid).get();

      Provider.of<AppData>(context).setUserData(User.fromDocument(doc));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)
        => HomeScreen()
        ),
      );
    }
    /*else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)
        => WaitingToLoginScreen()
        ),
      );
    }*/
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('Images/quotd.png'),
              SpinKitDoubleBounce(
                color: kHighlightColorGrey,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


