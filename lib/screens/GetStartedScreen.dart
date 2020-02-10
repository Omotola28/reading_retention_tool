import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reading_retention_tool/module/User.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'SignUpScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/SocialMediaButtons.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  bool isAuth = false;


  googleLogIn() {
    googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account){
       handleSignInWithGoogle(account);
    }, onError: (err){
      print('This is an $err');
    });

    googleSignIn.signInSilently(suppressErrors: false)
        .then((account){
            handleSignInWithGoogle(account);
    }).catchError((err){
      print('Sign in failed $err');
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
     // print('User signed in $account');
      setState(() {
        isAuth = true;
      });


    }
    else{
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 35.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Welcome',
                      style: kHeadingTextStyleDecoration,
                    ),
                    Text(
                      'Please login or signup to continue',
                      style: kTrailingTextStyleDecoration,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                child: Container(
                  child: Image.asset(
                    'Images/joyride.png',
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Sign In with',
                        style: kTrailingTextStyleDecoration,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialMediaButtons(icon: FontAwesomeIcons.facebookF, onTap: (){

                          },
                          ),
                          SocialMediaButtons(icon: FontAwesomeIcons.google, onTap: (){
                                googleLogIn();
                          },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        'Or continue with',
                        style: kTrailingTextStyleDecoration,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      ActionUserButton(color: Colors.white, title: "Sign Up", onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Dont have an account? ',
                            style: kTrailingTextStyleDecoration,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.popAndPushNamed(context, SignInScreen.id);
                            },
                            child: Text(
                              'Login',
                              style: kTrailingTextStyleDecoration.copyWith(color: kSecondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}







