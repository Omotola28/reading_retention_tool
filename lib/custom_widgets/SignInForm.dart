import 'package:flutter/material.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:flutter/services.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/custom_widgets/UserTextInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  final _auth = FirebaseAuth.instance;
//  final _sinInUsers = UserSignInAuth();
  String email, password;
  final _signInKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _signInKey,
              child: Container(
                width: double.infinity,
                height: 500,
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
                          UserTextInputField(
                            labelText: 'Password', validate: (value) => value.isEmpty ? 'Please enter your password' : null,
                            value: true,
                            savedValue: (value) => password = value,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -5.0,
                      height: 150.0,
                      child: Card(
                        elevation: 5.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: kHighlightColorGrey, style: BorderStyle.solid, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(top: 10.0),
                                alignment: Alignment.topCenter,
                                width: 500.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Checkbox(value: false, onChanged: (val){
                                          setState(() {

                                          });
                                        }, activeColor: kPrimaryColor,
                                        ),
                                        Text(
                                          "Remember me",
                                          style: kTrailingTextStyleDecoration,
                                        ),
                                      ],
                                    ),
                                    Text("Forgot Password?",
                                      style: kTrailingTextStyleDecoration,
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      child:  ActionUserButton(color: Colors.white, title: 'Sign In', onPressed: () async {
                        final form = _signInKey.currentState;
                        if(form.validate())
                        {
                          form.save();
                          print("email: $email, password: $password");
                          try {
                            final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
                            print("Result $result");
                            result != null ? Navigator.pushNamed(context, HomeScreen.id): print(result);
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
                            _signInKey.currentState.reset();

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

