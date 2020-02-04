import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

class UndefinedScreen extends StatelessWidget {

  final String name;

  const UndefinedScreen({Key key, this.name}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              //do something
            },
            padding: EdgeInsets.all(0.0),
            iconSize: 100.0,
            icon: Image.asset(
              'Images/quotd.png',
            ),
            // tooltip: 'Closes application',
            //    onPressed: () => exit(0),
          ),

        ],
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text('Route for this path $name is undefined'),
          ),
        ),
      ),
    );
  }
}
