import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class PayLoadReadyScreen extends StatefulWidget {
  @override
  _PayLoadReadyScreenState createState() => _PayLoadReadyScreenState();
}

class _PayLoadReadyScreenState extends State<PayLoadReadyScreen> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings()
    );

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("OnMessage: $message");
        showDialog(
            context: context,
            builder:  (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['title']),
              ),
              actions: <Widget>[
                FlatButton(onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'))
              ],
            )
        
        );
        /*final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(label: 'Go', onPressed: () => null),
        );
        
        Scaffold.of(context).showSnackBar(snackbar);*/
      },
      onResume: (Map<String, dynamic> message) async {
        print("Resume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("OnLaunch: $message");
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


