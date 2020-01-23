import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/CategoryScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';

class BookSpecificHighlightScreen extends StatefulWidget {
  final String bookId;

  BookSpecificHighlightScreen(this.bookId);

  //static String id = 'book_specific_highlight';

  @override
  _BookSpecificHighlightScreenState createState() =>
      _BookSpecificHighlightScreenState();
}

class _BookSpecificHighlightScreenState
    extends State<BookSpecificHighlightScreen> {
  final _store = Firestore.instance;

  static const _menuItems = <String>[
    'Share',
    'Edit',
    'Delete',
    'Categorise'
  ];

  //Shows the popup menu for each tile
  static List<PopupMenuItem<String>> _pop = _menuItems.map((String val) =>
        PopupMenuItem<String>(
            value: val,
            child: Text(val),
        )

  ).toList();

  final GlobalKey _menuKey = new GlobalKey();

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
              Navigator.popAndPushNamed(context, UserBooksListScreen.id);
            }),
        title: Text(
          'Book List',
          style: TextStyle(
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
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: _store
                    .collection('users')
                    .document(Provider.of<AppData>(context).uid)
                    .collection('books')
                    .document(widget.bookId)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> widgetHighlights = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final highlights = snapshot.data['highlights'];

                    for (var highly in highlights) {
                      //print(highly);
                      final highlightWidget =
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Card(
                              color: Color.fromRGBO(250, 249, 242, 1),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.all(20.0),
                                    subtitle: Text(
                                        highly.replaceAll(new RegExp(r' - '), ''),
                                        style: TextStyle(color: kDarkColorBlack),
                                    ),
                                    leading: Icon(CustomIcons.circle, size: 10.0, color: Colors.blueAccent,),
                                    trailing: PopupMenuButton(
                                        onSelected: (selectedDropDownItem) => handlePopUpMenuAction(selectedDropDownItem, context),
                                        itemBuilder: (BuildContext context) => _pop
                                    )
                                  ),
                                ],
                              ),
                            ),
                        );

                      widgetHighlights.add(highlightWidget);
                    }

                    print(snapshot.data['highlights'].length);
                    // Map<String, dynamic> listOfHighlights = jsonDecode(highlights);

                    /* listOfHighlights.forEach((key, value){
                                widgetHighlights.add(ListTile(
                                    contentPadding: EdgeInsets.all(20.0),
                                    subtitle: Text(value.replaceAll(new RegExp(r' - '), ''))
                                ));
                              });*/

                  }
                  return ListView.builder(
                      itemCount: snapshot.data['highlights'].length == null ? 0 : snapshot.data['highlights'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: widgetHighlights[index],
                        );
                      });
                }),
          )
        ],
      )),
    );
  }
}

/// When a [PopUpMenuItem] is selected, we perform the action here
void handlePopUpMenuAction(String value, BuildContext context) {
  switch (value) {
    case 'Share':
      {

      }
      break;

    case 'Edit':
      {
        //statements;
        print('');
      }
      break;

    case 'Delete':
      {


      }
      break;

    case 'Categorise':
      {

        Navigator.popAndPushNamed(context, CategoryScreen.id);

      }
      break;

    default:
      {
        //statements;
      }
      break;
  }

  print(value);
}
/*

GestureDetector(
child: Icon(
CustomIcons.down_open,
color: kHighlightColorDarkGrey,
),
onTap: () {

},
),*/
