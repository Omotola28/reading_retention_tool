import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/custom_widgets/ServiceSync.dart';

class ServiceSyncListPage extends StatefulWidget {
  @override
  _ServiceSyncListPageState createState() => _ServiceSyncListPageState();
}

class _ServiceSyncListPageState extends State<ServiceSyncListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
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
                  SizedBox(
                    height: 30.0,
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
      ),
    );
  }
}
