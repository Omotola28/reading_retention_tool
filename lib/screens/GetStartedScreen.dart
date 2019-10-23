import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SignUpScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/SocialMediaButtons.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';

//import 'CarouselWidget.dart';

class GetStartedScreen extends StatelessWidget {
  /* hexColor(String colorHexCode) {
    String color = '0xff';
    String newColor = color + colorHexCode;
    int colorInt = int.parse(newColor);
    return colorInt;
  }*/

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
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SignUpScreen();
                        }));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return SignInScreen();
                              }));
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






