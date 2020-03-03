import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/ProgressIndicators.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'dart:async';

class ShowInstapaperDialog extends StatefulWidget {
  @override
  _ShowInstapaperDialogState createState() => _ShowInstapaperDialogState();
}

class _ShowInstapaperDialogState extends State<ShowInstapaperDialog> {


  final  InstapaperLogo = 'https://firebasestorage.googleapis.com/v0/b/readingtool-479e1.appspot.com/o/Instapaper.png?alt=media&token=c9a0cf15-b4ea-494d-a2e8-36214fe4e739';
  final _instapaperEmail = TextEditingController(text: 'johndoe@gmail.com');
  final _instapaperPassword = TextEditingController(text: '-----------');
  var errorMessage = '';
  String payload = '';


 /* final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncInstapaper',
  );*/


  final HttpsCallable callable = CloudFunctions(region: 'europe-west2').getHttpsCallable(functionName: 'syncInstapaper',);


  Future<String> _callSyncInstapaper() async {
    var message;

    if(mounted){
      setState(() {
        payload = 'processing';
      });
    }

    if(!_instapaperEmail.text.contains('@')){
      if(mounted){
        setState(() {
          payload = '';
          errorMessage = 'Enter valid email address';
        });
      }

      return message;
    }

    try {
      dynamic resp = await callable.call(<String, dynamic>{
        'username' : _instapaperEmail.text,
        'password' : _instapaperPassword.text,
        'uid' : Provider
            .of<AppData>(context, listen: false)
            .userData
            .id,
      });

      print('VALUUES ${resp.data}');

      if (resp.data == 200) {

        print(resp.data);
        errorMessage = '';
        payload = '';
        Navigator.popAndPushNamed(
            context, InstapaperBookmarksRoute);
      }
      else if(resp.data == 403){
        if(mounted){
          setState(() {
            payload = '';
            errorMessage = 'Invalid user credentials';
          });
        }
      }
      else if(resp.data == 500){
        if(mounted){
          setState(() {
            payload = '';
            errorMessage = 'Network error!';
          });
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }

    return message;
  }


  bool _isUserDetailsEmpty(email, password){
    var isEmpty = false;

    if (_instapaperEmail.text == 'johndoe@gmail.com' || _instapaperPassword.text == '-----------') {
         if(mounted){
           setState(() {
             errorMessage = 'Complete details required';
           });
         }


        isEmpty = true;
    }
    else {
      errorMessage = '';
      isEmpty = false;
    }

    return isEmpty;
  }

  @override
  Widget build(BuildContext context) {

    FocusNode _emailNode = FocusNode();
    FocusNode _passwordNode = FocusNode();

    _emailNode.addListener(() {
      if (_emailNode.hasFocus) _instapaperEmail.clear();
    });

    _passwordNode.addListener(() {
      if (_passwordNode.hasFocus) _instapaperPassword.clear();
    });

    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: 200.0,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(height: 150.0),
                            Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  color: kPrimaryColor),
                            ),
                            Positioned(
                                top: 50.0,
                                left: 94.0,
                                child: Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(45.0),
                                      border: Border.all(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: 2.0),
                                      image: DecorationImage(
                                          image:
                                          NetworkImage(InstapaperLogo),
                                          fit: BoxFit.cover)),
                                ))
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                cursorColor: kDarkColorBlack,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(fontSize: 19, color: kDarkColorBlack, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 3.0)),
                                ),
                                controller: _instapaperEmail,
                                focusNode: _emailNode,
                                style: TextStyle(color: Colors.grey))),
                        SizedBox(height: 8.0),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                cursorColor: kDarkColorBlack,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 19, color: kDarkColorBlack, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 3.0)),
                                ),
                                controller: _instapaperPassword,
                                focusNode: _passwordNode,
                                style: TextStyle(color: Colors.grey))),
                        SizedBox(height: 15.0),
                        Text(errorMessage == null ? '' : errorMessage,
                          style: TextStyle(color: Colors.deepOrange),),
                        payload == '' ?
                        Container(
                          width: 200,
                          child: OutlineButton(
                            disabledBorderColor: kPrimaryColor,

                            child: Center(
                              child: Text(
                                'Submit',
                                style: kHeadingTextStyleDecoration.copyWith(
                                    color: kDarkColorBlack,
                                    letterSpacing: 1
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (!_isUserDetailsEmpty(_instapaperEmail.text, _instapaperPassword.text)) {
                                _callSyncInstapaper().then((val) {
                                  print(val);
                                });
                              }
                            },
                          ),
                        )
                            : Center(
                          child: Container(child: circularProgressIndicator(),),)
                      ],
                    ))),
          ),
        ),
      ],

    );
  }
}
