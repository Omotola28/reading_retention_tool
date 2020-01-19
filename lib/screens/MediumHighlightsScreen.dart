import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';


class MediumHighlightsScreen extends StatefulWidget {

  static String id = 'medium_highlights';

  @override
  _MediumHighlightsScreenState createState() => _MediumHighlightsScreenState();
}

class _MediumHighlightsScreenState extends State<MediumHighlightsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medium Highlights', style: TextStyle(
          color: kDarkSocialBtnColor,
        ),),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("user").snapshots(),
          builder: (context, snapshot){
            print(snapshot);
            if(snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else {
              return ListView.builder(itemBuilder: null);
            }
          }
      ),
    );
  }
}
