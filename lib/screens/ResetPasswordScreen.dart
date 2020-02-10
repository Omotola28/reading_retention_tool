import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ResetPasswordForm.dart';


class ResetPasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 35.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              'Reset Password',
              style: kHeadingTextStyleDecoration,
            ),
            Text(
              'Please enter your email address to reset your password',
              style: kTrailingTextStyleDecoration,
            ),
            ResetPasswordForm(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(
                      "Dont have an account? ",
                      style: TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 12.0,
                        color: kHighlightColorDarkGrey,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        => SignUpScreen()
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
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
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Do you have an account? ",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 12.0,
                      color: kHighlightColorDarkGrey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        => SignInScreen()
                        ),
                      );
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

