import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/utils/share.dart';




class HighlightOfTheDayScreen extends StatefulWidget {

  //final NavigationService _navigationService = locator<NavigationService>();
  final String payload;

  HighlightOfTheDayScreen(this.payload);

  @override
  _HighlightOfTheDayScreenState createState() => _HighlightOfTheDayScreenState();
}

class _HighlightOfTheDayScreenState extends State<HighlightOfTheDayScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: kDarkColorBlack,
            ),
            onPressed: () {
              Navigator.pop(context, true);
              //widget._navigationService.goBack();
            }),
        title: Text(
          'Highlight of the Day',
          style: TextStyle(
              color: kDarkColorBlack,
              fontSize: 18.0,
          ),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
            },
            padding: EdgeInsets.all(0.0),
            iconSize: 100.0,
            icon: Image.asset(
              'Images/quotd.png',
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
            children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2.0,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(20),
                            subtitle: Text(widget.payload),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('SHARE', style: TextStyle(color: kPrimaryColor),),
                                onPressed: () {
                                  ShareHighlight().share(context, widget.payload);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
      ),
    );
  }
}
