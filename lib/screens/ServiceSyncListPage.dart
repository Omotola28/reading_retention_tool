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
                            Image.asset("Images/Instapaper.png"),
                            "Instatpaper",
                            "Sync all your highlights from articles you have read online",
                            'instapaper',
                          ),
                          ServiceSync(
                            Image.asset("Images/medium.png"),
                            "Medium",
                            "Sync highlights from medium",
                            'medium',
                          ),
                          ServiceSync(
                            Image.asset("Images/kindle.png"),
                            "Kindle",
                            "Sync highlights from your kindle ebooks/app",
                            "kindle",
                          ),
                          ServiceSync(
                              Image.asset("Images/hmq.png"),
                              "Highlight My Quotes",
                              "Add highlights manually from print books you have read",
                              "hmq"
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
