import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/SignInForm.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ResetPasswordForm.dart';


class ResetPasswordScreen extends StatelessWidget {

  static String id = 'resetPassword_screen';

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
                      Navigator.pushNamed(context, SignUpScreen.id);
                     /* Navigator.push(context, MaterialPageRoute(builder: (context){
                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                        return SignUpScreen();
                      }));*/
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
          ],
        ),
      ),
    );
  }
}

