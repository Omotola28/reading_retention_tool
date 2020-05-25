import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:flutter/scheduler.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';


class WelcomePage extends StatefulWidget {


  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {


  @override
  void initState(){
    super.initState();
    //This function loadGetStartedScreen should be called when this screen shows after 3 secs
    FirebaseAuth.instance.currentUser().then((val){
      print('FIREBASEUSER $val');
    });

    print( 'GOOGLE ${UserAuth.googleSignIn.currentUser}');
    SchedulerBinding.instance.addPostFrameCallback((_) => loadGetStartedScreen());
  }


  void loadGetStartedScreen(){
    Future.delayed(Duration(seconds: 1), () {


      ///Silently login if the user is a firebase user
      FirebaseAuth.instance.currentUser().then((currentUser){
          if(currentUser != null){
            handleSilentFirebaseLogin();
          }
          else{
            Navigator.popAndPushNamed(context, GetStartedScreenRoute);
          }
      });

    });
  }


  handleSilentFirebaseLogin() async {
    var hasUserLoggedIn = await UserAuth.isFirebaseUserLoggedIn();

    if(hasUserLoggedIn){

      var user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot doc = await Firestore.instance.collection('users').document(user.uid).get();

      Provider.of<AppData>(context, listen: false).setUserData(User.fromDocument(doc));

      Navigator.popAndPushNamed(context, HomeScreenRoute);
    }

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


