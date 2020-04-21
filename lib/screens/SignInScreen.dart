import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/SignInForm.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';


class SignInScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 35.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              'Sign In',
              style: kHeadingTextStyleDecoration,
            ),
            Text(
              'Please Sign In to continue with the app',
              style: kTrailingTextStyleDecoration,
            ),
            SignInForm(),
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
                      Navigator.pushNamed(context, SignUpRoute);
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

