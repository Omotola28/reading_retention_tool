import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/SignUpForm.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';

class SignUpScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 35.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              'Sign Up',
              style: kHeadingTextStyleDecoration,
            ),
            Text(
              'Enter your details below to sign up',
              style: kTrailingTextStyleDecoration,
            ),
            SignUpForm(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "Have an account already? ",
                      style: kTrailingTextStyleDecoration,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignInRoute);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 12.0,
                        color: kSecondaryColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

