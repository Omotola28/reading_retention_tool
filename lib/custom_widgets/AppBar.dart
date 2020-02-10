import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

AppBar header(){
   return AppBar(
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
   );
}