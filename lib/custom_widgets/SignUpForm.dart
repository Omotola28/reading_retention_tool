import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:reading_retention_tool/custom_widgets/UserTextInputField.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/service/auth_service.dart';



class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _auth = FirebaseAuth.instance;
  User _user = User();
  final _signUpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _signUpKey,
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
                              top: 10.0, bottom: 10.0),
                          height: 2.0,
                          width: 50.0,
                          color: kHighlightColorGrey,
                        ),
                        UserTextInputField(labelText: 'Name',
                          validate: (value) {
                            if (value.isEmpty ||  value.trim().length < 5 ) {
                              return 'Username too short enter atleast 5 characters';
                            }
                            else if ( value.trim().length > 12 ){
                              return 'Username is too long, recommend 5-11 characters';
                            }

                            return null;


                          },
                          value: false,
                          savedValue:  (value) => _user.displayName = value,
                        ),
                        UserTextInputField(
                          labelText: 'Email', validate: (value) {
                          if (value.isEmpty || !RegExp(pattern).hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          else {

                            return null;
                          }

                        },
                          value: false, inputType: TextInputType.emailAddress,
                          savedValue:  (value) =>  _user.email = value,
                        ),
                        UserTextInputField(labelText: 'Password',
                          validate: (value) {
                            if (value.isEmpty || value.trim().length < 7 ) {
                              return 'Password is too short';
                            }

                            return null;

                          },
                          value: true,
                          savedValue:  (value) => _user.password = value,
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
                        side: BorderSide(
                            color: kHighlightColorGrey,
                            style: BorderStyle.solid,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),

                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            alignment: Alignment.topCenter,
                            width: 400.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                               /* Checkbox(value: _user.rememberMe, onChanged: (val){
                                  setState(() {
                                   // _user.rememberMe = val;
                                  });
                                }, activeColor: kPrimaryColor,
                                ),*/
                                Text(
                                  "I agree with your Privacy Policy",
                                  style: kTrailingTextStyleDecoration,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20.0,
                      child: ActionUserButton(color: Colors.white,
                          title: 'Sign Up',
                          onPressed: () async {
                            final form = _signUpKey.currentState;
                            if(form.validate())
                            {
                              form.save();
                              try{
                                final result = await UserAuth.registerUser(_user.email, _user.password, _user.displayName);

                                 result  != null ? Navigator.popAndPushNamed(context, SignInScreen.id) : print(result);
                              } on PlatformException catch (e) {
                                //e.code
                                switch(e.code)
                                {
                                  case "ERROR_INVALID_EMAIL":
                                    print(e.code);
                                }
                                _signUpKey.currentState.reset();
                              }
                            }
                          })
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


