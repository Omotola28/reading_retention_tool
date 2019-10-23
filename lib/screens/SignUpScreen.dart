import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/SignUpForm.dart';
import 'package:reading_retention_tool/constants/constants.dart';

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
          ],
        ),
      ),
    );
  }
}
