import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:flutter/services.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/custom_widgets/UserTextInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';



class ResetPasswordForm extends StatefulWidget {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {

  final _auth = FirebaseAuth.instance;

  String email, _warning;
  final _resetPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _resetPasswordKey,
              child: Container(
                width: double.infinity,
                height: 350,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2.0,
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsetsDirectional.only(
                                top: 10.0, bottom: 50.0),
                            height: 2.0,
                            width: 50.0,
                            color: kHighlightColorGrey,
                          ),
                          UserTextInputField(
                            labelText: 'Email', validate: (value) => value.isEmpty ? 'Please enter an email' : null,
                            value: false,
                            savedValue:  (value) => email = value,
                            inputType: TextInputType.emailAddress,
                          ),

                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      child:  ActionUserButton(color: Colors.white, title: 'Reset Password', onPressed: () async {
                        final form = _resetPasswordKey.currentState;
                        if(form.validate())
                        {
                          form.save();

                          try {
                            final result = await _auth.sendPasswordResetEmail(email: email);
                            _warning = "A Password reset link has been sent to $email";
                            setState(() {
                              Navigator.pushNamed(context, SignInScreen.id);
                            });
                          } on PlatformException catch (e) {
                                  print(e);
                            switch (e.code) {
                              case "ERROR_USER_NOT_FOUND":
                                print(e.code);
                                break;
                              case "ERROR_WRONG_PASSWORD":
                                print(e.code);
                                break;
                              default:
                                break;
                            }
                            _resetPasswordKey.currentState.reset();

                          }

                        }
                      },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}

