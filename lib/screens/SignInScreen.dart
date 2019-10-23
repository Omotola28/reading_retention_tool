import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/SignInForm.dart';
import 'package:reading_retention_tool/constants/constants.dart';

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
          ],
        ),
      ),
    );
  }
}
