import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'dart:convert';


class CategoryTile extends StatefulWidget {
  final String categoryTitle;
  final Color categoryColor;
  final String whichService;


  CategoryTile({this.categoryTitle, this.categoryColor, this.whichService});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {

  final _store = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var highlightObj = Provider.of<AppData>(context).bookSpecificHighlights;
    var index = Provider.of<AppData>(context).categoryIndex;


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


       if(widget.whichService == 'kindle'){
         //Saving the whole obj back to firebase datastore after adding category.
         _store.collection("kindle")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .collection("books")
             .document(Provider.of<AppData>(context, listen: false).bookName)
             .updateData({"highlights": highlightObj});

         Navigator.pop(context);
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context)
           => BookSpecificHighlightScreen(Provider.of<AppData>(context, listen: false).bookName)
           ),
         );
       }
       else if(widget.whichService == 'medium'){
         Firestore.instance.collection("medium")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .updateData({"mediumHighlights": highlightObj});
         
         Navigator.popAndPushNamed(context, MediumHighlightsSyncRoute, arguments: 'success');

       }
       else if(widget.whichService == 'instapaper'){


         Firestore.instance.collection("instapaperhighlights")
             .document(Provider.of<AppData>(context, listen: false).bookmarkID)
             .updateData({"instaHighlights": highlightObj});

         Navigator.popAndPushNamed(context, BookmarkHighlightRoute, arguments: Provider.of<AppData>(context, listen: false).bookmarkID);
       }
      },
    );
  }
}
