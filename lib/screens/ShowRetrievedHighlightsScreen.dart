import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/ManageCategory.dart';
import 'dart:async';
import 'package:async/async.dart';


class ShowCatHighlightScreen extends StatefulWidget {

  String _categoryID;
  ShowCatHighlightScreen(this._categoryID);

  @override
  _ShowCatHighlightScreenState createState() =>
      _ShowCatHighlightScreenState();
}

class _ShowCatHighlightScreenState
    extends State<ShowCatHighlightScreen> {

  final _store = Firestore.instance;
  int objLength;
  bool userHasData = false;
  final AsyncMemoizer _memoizer = AsyncMemoizer(); //Stops future builder from going off like a thousand times


 Future<dynamic> _getKindleHighlights() {
    return this._memoizer.runOnce(() async {
      var data =  await _store
          .collection('category')
          .document(Provider.of<AppData>(context).userData.id)
          .collection('userCategories')
          .document(widget._categoryID).get();

      if(data.exists){
        setState(() {
          userHasData = true;
        });
      }
      else{
        setState(() {
          userHasData = false;
        });
      }

      return data;
    });
  }

  _saveNoOfHighlights(int no) async {
    DocumentSnapshot doc = await Firestore.instance
                                          .collection('highlightsNo')
                                          .document(Provider.of<AppData>(context).userData.id).get();

    if(!doc.exists){
      Firestore.instance.collection('highlightsNo').document(Provider.of<AppData>(context, listen: false).userData.id).setData({
        "number": no,
      }).catchError((e) => print(e));
    }

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:  header(headerText: 'Kindle Highlights', context: context , screen: ManageCategory() ),
     body: SafeArea(
       child: FutureBuilder (
         future:  _getKindleHighlights(),
         builder: (context, snapshot) {
           List<Widget> widgetHighlights = [];

           if(userHasData)  {

             List highlights = snapshot.data['categoryHighlights'];


            // _saveNoOfHighlights(highlights.length);
             if(highlights == null){
               return Container(
                 child: Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Image.asset(
                         'Images/notfound.png',
                       ),
                       Text('No Highlights Extracted',
                         style: TextStyle(
                             color: kDarkColorBlack),
                       ),
                     ],
                   )


                 ),
               );
             }
             else{
               for (var index = 0; index < highlights.length; index++) {

                 var cleanseText = highlights[index]['highlight'].replaceAll(new RegExp(r' - '), '');
                 final highlightWidget =
                 Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Card(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         ListTile(
                           contentPadding: EdgeInsets.all(20.0),
                           subtitle: Text(cleanseText),
                         ),
                       ],
                     ),
                   ),
                 );

                 widgetHighlights.add(highlightWidget);
               }
             }

           } else {
             return Center(
               child: CircularProgressIndicator(),
             );
           }
           return ListView.builder(
             itemCount: snapshot.data['categoryHighlights'].length == null ? 0 : snapshot.data['categoryHighlights'].length,
             itemBuilder: (context, index) {
               return widgetHighlights[index];
             },
           );
         }
       ),
     ),
    );
  }
}

