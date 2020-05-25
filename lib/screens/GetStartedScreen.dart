import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/SocialMediaButtons.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:reading_retention_tool/module/app_data.dart';



class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((val){
      print('FIREBASEUSER $val');
    });

    print( 'GOOGLE ${UserAuth.googleSignIn.currentUser}');
  }


  _handleSignInWithGoogle(Future<User> account){

    account.then((userData){
      print(userData.toJson());
      if(userData !=null){
        Provider.of<AppData>(context, listen: false).setUserData(userData);
        Navigator.popAndPushNamed(context, HomeScreenRoute);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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

                            SocialMediaButtons(icon: FontAwesomeIcons.google, onTap: (){
                              var user = UserAuth.googleLogIn();
                              _handleSignInWithGoogle(user);
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
                          Navigator.pushNamed(context, SignUpRoute);
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
                                Navigator.popAndPushNamed(context, SignInRoute);
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
      ),
    );
  }
}







