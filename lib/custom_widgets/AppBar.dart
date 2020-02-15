import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

AppBar header({bool implyLeading = true, String headerText = '' , BuildContext context, dynamic screen}){
   return AppBar(
       automaticallyImplyLeading: implyLeading,
       leading: implyLeading ?
       FlatButton(
           child: Icon(
             Icons.arrow_back_ios,
             color: kDarkColorBlack,
           ),
           onPressed: () {

             Navigator.pop(context);
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context)
               => screen
               ),
             );
           }

       ) : Container() ,
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
         ),
       ],
     title: Text(headerText, style: TextStyle(
         color: kDarkSocialBtnColor,
         fontSize: 18.0
        ),
     ),

   );
}