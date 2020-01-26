import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'dart:async';

import 'package:reading_retention_tool/screens/HomeScreen.dart';

class ShowRetrievedHightlightsScreen extends StatefulWidget {

  static String id = 'show_retrieved_highlights_screen';

  //List object for the builder, was better to pass it than store in provider
  List obj = [];
  String _fileName;
  ShowRetrievedHightlightsScreen(this.obj, this._fileName);

  @override
  _ShowRetrievedHightlightsScreenState createState() =>
      _ShowRetrievedHightlightsScreenState();
}

class _ShowRetrievedHightlightsScreenState
    extends State<ShowRetrievedHightlightsScreen> {

  final _store = Firestore.instance;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    print("I am done");
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
            child: Icon(
                Icons.arrow_back_ios,
                color: kDarkColorBlack,
            ),
            onPressed: () {
           _store.collection("users")
                  .document(Provider.of<AppData>(context).uid)
                  .collection("books")
                  .document(widget._fileName)
                  .setData({"highlights": widget.obj}, merge: true);
              Navigator.popAndPushNamed(context, HomeScreen.id);
            }

            ),
        title: Text('Edit Highlights', style: TextStyle(
          color: kDarkSocialBtnColor,
        ),
        ),
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              print('jhjkja');
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

     body: ListView.builder(
        itemCount: widget.obj == null ? 0 : widget.obj.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.all(20.0),
                    subtitle: Text(widget.obj[index]['highlight'].replaceAll(new RegExp(r' - '), '')),
                    trailing: GestureDetector(
                        child: Icon(
                            CustomIcons.down_open,
                            color: kHighlightColorDarkGrey,
                        ),
                      onTap: (){
                            showHighlightDialog(
                                context, widget.obj[index]['highlight'].replaceAll(new RegExp(r' - '), ''), index)
                                .then((val){
                              switch (Provider.of<AppData>(context).whatActionButton) {
                                case 'Save':
                                  {
                                    widget.obj[index] = Provider.of<AppData>(context).savedString;
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
                                    widget.obj.removeAt(index);
                                    widget.obj.length = widget.obj.length - 1;

                                  }
                                  break;

                                default:
                                  {
                                    //statements;
                                  }
                                  break;
                              }

                                  print(val);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
                      //print(_highlightController.text);
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
                      /* ... */
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
                      /* ... */
                    },
                  ),
                ],
            );
    }
    );

}