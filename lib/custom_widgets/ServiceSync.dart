import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/screens/ProgressIndicators.dart';
import 'dart:async';


class ServiceSync extends StatelessWidget {
  ServiceSync({
    this.thumbnail,
    this.title,
    this.subtitle,
    this.screen,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String screen;

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncInsapaper',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (screen) {
          case 'kindle':
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => KindleHighlightsSync()
                ),
              );
            }
            break;

          case 'medium':
            {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowMediumDialog();
                  });

            }
            break;

          case 'instapaper':
            {

            }
            break;

          case 'Delete':
            {

            }
            break;

          default:
            break;
        }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kHighlightColorGrey,
                      blurRadius: 6.0, // has the effect of softening the shadow
                      spreadRadius: 1.0, // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        1.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: thumbnail,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                          Text(
                            '$subtitle',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShowMediumDialog extends StatefulWidget {


  @override
  _ShowMediumDialogState createState() => _ShowMediumDialogState();
}

class _ShowMediumDialogState extends State<ShowMediumDialog> {

  String payload = '';
  var errorMessage= '';


  final _mediumUsername = TextEditingController(text: '@username');

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncMedium',
  );

  Future<String> _callSyncMedium()  async {

    var message;

    setState(() {
      payload = 'processing';
    });

    if(_mediumUsername.text == '@username')
      Provider.of<AppData>(context, listen: false).setMeduimUserName(null);
    else
      Provider.of<AppData>(context, listen: false).setMeduimUserName(_mediumUsername.text);

    try {

      dynamic resp = await callable.call(<String, dynamic>{
        'name': _mediumUsername.text,
        'uid': Provider.of<AppData>(context, listen: false).userData.id
      });

      if(resp.data != 'invalid'){
        print(resp.data);
        errorMessage = '';
        Navigator.pushNamed(context, MediumHighlightsSyncRoute, arguments: resp.data);
      }
      else{
        setState(() {
          payload = '';
          message = 'Username invalid';
        });
      }

    } catch (e, s) {
      print(e);
      print(s);
    }

    return message;
  }

  bool isUserNameEmpty(String name){
     var isEmpty = false;

    if(_mediumUsername.text == '@username'){
      setState(() {
        errorMessage = 'Username not provided';
      });

      isEmpty = true;
    }
    else{
      errorMessage = '';
      isEmpty = false;
    }

    return isEmpty;
  }

  @override
  Widget build(BuildContext context) {

    FocusNode _focusNode = FocusNode();

    _focusNode.addListener((){
      if (_focusNode.hasFocus) _mediumUsername.clear();
    });

    return AlertDialog(
        title: Image.asset(
          "Images/medium.png",
          height: 50,
          width: 50,
        ),
        content: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter medium username',
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
            ),
            controller: _mediumUsername,
            focusNode: _focusNode,
            style: TextStyle(color: Colors.grey)),
        actions: <Widget>[
          Text(errorMessage == null ? '' : errorMessage, style: TextStyle(color: Colors.red),),
          payload == '' ?
              FlatButton(
            color: kPrimaryColor,
            child: Text(
              'Sync Highlights',
              style: kHeadingTextStyleDecoration.copyWith(color: Colors.white),
            ),
            onPressed: () async {
              print('VAL ${_mediumUsername.text}');
               if(!isUserNameEmpty(_mediumUsername.text)){
                 _callSyncMedium().then((val){
                   setState(() {
                     errorMessage = val;
                   });
                  // print(val);
                 });
               }

            },
          )
              : Center(child: Container(child: circularProgressIndicator(),),)
        ]
    );
  }
}


/*
Future<bool> showMediumDialog(BuildContext context){




  return showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            "Images/medium.png",
            height: 50,
            width: 50,
          ),
          content: TextFormField(
              validator: (value) => value.isEmpty ? 'Please enter your username' : null,
              decoration: InputDecoration(
                labelText: 'Enter medium username',
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
              ),
              controller: _mediumUsername,
              focusNode: _focusNode,
              style: TextStyle(color: Colors.grey),

              onTap: () {

              }),
          actions: <Widget>[
               FlatButton(
                    color: kPrimaryColor,
                    child: Text(
                      'Sync Highlights',
                      style: kHeadingTextStyleDecoration.copyWith(color: Colors.white),
                ),
               onPressed: () async {
                    if(_mediumUsername.text == '@username')
                        Provider.of<AppData>(context, listen: false).setMeduimUserName(null);
                    else
                        Provider.of<AppData>(context, listen: false).setMeduimUserName(_mediumUsername.text);

                    try {

                     dynamic resp = await callable.call(<String, dynamic>{
                        'name': _mediumUsername.text,
                        'uid': Provider.of<AppData>(context, listen: false).userData.id
                      });



                      print(resp.data);
                      Navigator.pushNamed(context, MediumHighlightsSyncRoute, arguments: resp.data);

                    } catch (e, s) {
                      print(e);
                      print(s);
                    }


               },
          ),
        ]
        );
      }
  );
}*/
