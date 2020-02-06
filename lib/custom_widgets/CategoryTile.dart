import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'dart:convert';


class CategoryTile extends StatefulWidget {
  final String categoryTitle;
  final Color categoryColor;


  CategoryTile({this.categoryTitle, this.categoryColor});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {

  final _store = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var highlightObj = Provider.of<AppData>(context).bookSpecificHighlights;
    var index = Provider.of<AppData>(context).categoryIndex;
    List categorised = [];

    return ListTile(
       leading:  Padding(
         padding: const EdgeInsets.only(top: 6.0),
         child: Icon(
           CustomIcons.circle,
           color: widget.categoryColor,
           size: 10.0,
         ),
       ),
      title: Text(widget.categoryTitle.toLowerCase()),

      onTap: (){

       String colorString = widget.categoryColor.toString(); //Gets the Colour Obj as a string
       String colorHex = colorString.split('(0xff')[1].split(')')[0];


       highlightObj[index]['category'] = widget.categoryTitle;
       highlightObj[index]['color'] = '#'+colorHex;

      // print(Provider.of<AppData>(context).bookName);

      //Saving the whole obj back to firebase datastore after adding category.
       _store.collection("users")
           .document(Provider.of<AppData>(context).uid)
           .collection("books")
           .document(Provider.of<AppData>(context).bookName)
           .updateData({"highlights": highlightObj});

       Navigator.pop(context);
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context)
         => HomeScreen()
         ),
       );

      },
    );
  }
}
