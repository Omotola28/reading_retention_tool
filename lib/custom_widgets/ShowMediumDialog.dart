import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:reading_retention_tool/screens/ProgressIndicators.dart';
import 'dart:async';


class ShowMediumDialog extends StatefulWidget {


  @override
  _ShowMediumDialogState createState() => _ShowMediumDialogState();
}

class _ShowMediumDialogState extends State<ShowMediumDialog> {

  String payload = ''; //Trying the simulate get update data from a service to determine next step of action
  var errorMessage = '';
  final mediumLogo = 'https://firebasestorage.googleapis.com/v0/b/readingtool-479e1.appspot.com/o/medium.png?alt=media&token=f711d1d3-5609-4261-803e-0cc1d2340a63';


  final _mediumUsername = TextEditingController(text: '@username');

  final HttpsCallable callable = CloudFunctions(region: 'europe-west2').getHttpsCallable(functionName: 'syncMedium',);

  Future<String> _callSyncMedium() async {
    var message;

    ///Saving some waiting time
    if(!_mediumUsername.text.contains('@')){
        return 'Username must start with @';
    }

    if(mounted){
      setState(() {
        payload = 'processing';
      });
    }

    try {
      dynamic resp = await callable.call(<String, dynamic>{
        'name': _mediumUsername.text,
        'uid': Provider
            .of<AppData>(context, listen: false)
            .userData
            .id
      });

      if (resp.data != 'invalid') {
        print(resp.data);
        errorMessage = '';
        Navigator.pushNamed(
            context, MediumHighlightsSyncRoute, arguments: resp.data);
      }
      else {
        if(mounted){
          setState(() {
            payload = '';
            message = 'Username invalid';
          });
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }

    return message;
  }

  bool isUserNameEmpty(String name) {
    var isEmpty = false;

    if (_mediumUsername.text == '@username') {
      setState(() {
        errorMessage = 'Username not provided';
      });

      isEmpty = true;
    }
    else {
      errorMessage = '';
      isEmpty = false;
    }

    return isEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    _mediumUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _mediumUsername.clear();
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
                    height: MediaQuery.of(context).size.height / 2,
                    width: 200.0,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(height: 140.0),
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
                                          NetworkImage(mediumLogo),
                                          fit: BoxFit.cover)),
                                ))
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                                cursorColor: kDarkColorBlack,
                                decoration: InputDecoration(
                                  labelText: 'Enter medium username',
                                  labelStyle: TextStyle(fontSize: 19, color: kDarkColorBlack, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColor, width: 3.0)),
                                ),
                                controller: _mediumUsername,
                                focusNode: _focusNode,
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

                              if (!isUserNameEmpty(_mediumUsername.text)) {
                                await _callSyncMedium().then((val) {
                                  if(mounted){
                                    setState(() {
                                      errorMessage = val;
                                    });
                                  }
                                }).catchError((err){
                                  setState(() {
                                    errorMessage = 'request taking longer than expected';
                                  });
                                });
                              }
                            },
                          ),
                        )
                            : Center(
                          child: Column(
                            children: <Widget>[
                              Text('Might take a while please come back later'),
                              Container(child: circularProgressIndicator(),),
                            ],
                          ),)
                      ],
                    ))),
          ),
        )
      ],

    );
  }
}
