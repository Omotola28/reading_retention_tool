import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/custom_widgets/ServiceSync.dart';
import 'dart:async';

class ServiceSyncListPage extends StatefulWidget {

  final currentUser;

  ServiceSyncListPage(this.currentUser);

  @override
  _ServiceSyncListPageState createState() => _ServiceSyncListPageState();
}

class _ServiceSyncListPageState extends State<ServiceSyncListPage> {

  Future<int> _getNoOfHighlights() async {

    DocumentSnapshot doc = await Firestore.instance
        .collection('highlightsNo').document(widget.currentUser).get();

    print(doc.data['number']);
    return doc.data['number'];

  }


  @override
  Widget build(BuildContext context) {

    final noOfHighlights = _getNoOfHighlights().then((val){
      return val;
    });
    return SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[

                      Text(
                          "Sync Highlights",
                          style: kHeadingTextStyleDecoration.copyWith(fontSize: 25.0),
                      ),
                      Text(
                        Provider.of<AppData>(context).noOfHighlights.toString() + ' Highlights Added',
                        style: kTrailingTextStyleDecoration,
                      ),
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20.0),
                        children: <Widget>[
                          ServiceSync(
                            thumbnail: Image.asset("Images/Instapaper.png"),
                            title: "Instatpaper",
                            subtitle: "Sync all your highlights from articles you have read online",
                            screen: 'instapaper',
                          ),
                          ServiceSync(
                            thumbnail: Image.asset("Images/medium.png"),
                            title: "Medium",
                            subtitle: "Sync highlights from medium",
                            screen: 'medium',
                          ),
                          ServiceSync(
                            thumbnail: Image.asset("Images/kindle.png"),
                            title: "Kindle",
                            subtitle: "Sync highlights from your kindle ebooks/app",
                            screen: "kindle",
                          ),
                          ServiceSync(
                              thumbnail: Image.asset("Images/hmq.png"),
                              title: "Highlight My Quotes",
                              subtitle: "Add highlights manually from print books you have read"
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
          ),
        ),
      );
  }
}
