import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/screens/ProgressIndicators.dart';

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

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncInsapaper',
  );

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

    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        child: Container(
            height: MediaQuery.of(context).size.height / 1.9,
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
                        'Sync Highlights',
                        style: kHeadingTextStyleDecoration.copyWith(
                            color: kDarkColorBlack,
                            letterSpacing: 1
                        ),
                      ),
                    ),
                    onPressed: () async {

                    },
                  ),
                )
                    : Center(
                  child: Container(child: circularProgressIndicator(),),)
              ],
            )));
  }
}
