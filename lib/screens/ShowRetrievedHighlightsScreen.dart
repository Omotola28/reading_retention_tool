import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'dart:async';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';

class ShowRetrievedHightlightsScreen extends StatefulWidget {

  String _fileName;
  ShowRetrievedHightlightsScreen(this._fileName);

  @override
  _ShowRetrievedHightlightsScreenState createState() =>
      _ShowRetrievedHightlightsScreenState();
}

class _ShowRetrievedHightlightsScreenState
    extends State<ShowRetrievedHightlightsScreen> {

  final _store = Firestore.instance;
  int objLength;
  bool userHasData = false;

  Future<DocumentSnapshot> _getKindleHighlights() async {
        var data =  await _store
        .collection('kindle')
        .document(Provider.of<AppData>(context).userData.id)
        .collection('books')
        .document(widget._fileName).get();

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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:  header(headerText: 'Kindle Highlights', context: context , screen: UserBooksListScreen() ),
     body: FutureBuilder (
       future:  _getKindleHighlights(),
       builder: (context, snapshot) {
         List<Widget> widgetHighlights = [];

         if(userHasData)  {

           List highlights = snapshot.data['highlights'];

           for (var index = 0; index < highlights.length; index++) {

             final highlightWidget =
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: Card(
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     ListTile(
                       contentPadding: EdgeInsets.all(20.0),
                       subtitle: Text(highlights[index]['highlight'].replaceAll(new RegExp(r' - '), ''),),
                       //trailing: GestureDetector(
                        /* child: Icon(
                           CustomIcons.down_open,
                           color: kHighlightColorDarkGrey,
                         ),
                         onTap: (){

                  *//*         showHighlightDialog(
                               context,
                               highlights[index]['highlight'].replaceAll(new RegExp(r' - '), ''), index)
                               .then((val){
                             switch (Provider.of<AppData>(context).whatActionButton) {
                               case 'Save':
                                 {
                                   print(highlights[index]['highlight'] );
                                   highlights[index]['highlight'] = Provider.of<AppData>(context).savedString;
                                 }
                                 break;

                               case 'Favourite':
                                 {
                                   //statements;
                                   print('hhjhjhj');
                                 }
                                 break;

                               case 'Delete':
                                 {

                                 }
                                 break;

                               default:
                                 {
                                   //statements;
                                 }
                                 break;
                             }

                             print(val);
                           });*//*
                         },*/
                       //),
                     ),
                   ],
                 ),
               ),
             );

             widgetHighlights.add(highlightWidget);
           }
         } else {
           return Center(
             child: CircularProgressIndicator(),
           );
         }
         return ListView.builder(
           itemCount: snapshot.data['highlights'].length == null ? 0 : snapshot.data['highlights'].length,
           itemBuilder: (context, index) {
             return widgetHighlights[index];
           },
         );
       }
     ),
    );
  }
}

//NO POINT HAVING TWO SCREENS THAT DO THE SAME THING.
/*
Future<bool> showHighlightDialog(BuildContext context, String highlight, int index){

    final _highlightController = TextEditingController(text: highlight);
    //TODO: Inorder to update the list for the index when a tile is deleted we have to use set state
    return showDialog(context: context,
        builder: (BuildContext context){
            return AlertDialog(
                content: TextFormField(

                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    controller: _highlightController,
                    //showing save button for all the tiles
                    onTap: () {
                      //something(obj[index].replaceAll(new RegExp(r' - '), ''));
                    }),
                actions: <Widget>[
                  FlatButton(
                    child: Icon(
                      CustomIcons.check,
                      color: kHighlightColorDarkGrey,
                    ),
                    onPressed: () {
                      Provider.of<AppData>(context).setWhatActionButton('Save');
                      Provider.of<AppData>(context).setSavedHighlight(_highlightController.text);

                      Navigator.of(context).pop(true);
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      CustomIcons.heart,
                      color: kHighlightColorDarkGrey,
                    ),
                    onPressed: () {
                      Provider.of<AppData>(context).setWhatActionButton('Favourite');
                      Navigator.of(context).pop(true);
                      */
/* ... *//*

                    },
                  ),
                  FlatButton(
                    child: Icon(
                      CustomIcons.trash,
                      color: kHighlightColorDarkGrey,
                    ),
                    onPressed: () {
                      Provider.of<AppData>(context).setWhatActionButton('Delete');
                      Navigator.of(context).pop(true);
                      */
/* ... *//*

                    },
                  ),
                ],
            );
    }
    );


}*/