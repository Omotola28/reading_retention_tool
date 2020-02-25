import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/utils/share.dart';



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
  var highlights = [];


  static const _menuItems = <String>[
    'Share',
    'Edit',
    'Categorise',
    'Delete',
  ];

  //Shows the popup menu for each tile
  static List<PopupMenuItem<String>> _pop = _menuItems.map((String val) =>
        PopupMenuItem<String>(
            value: val,
            child: Text(val),
        )

  ).toList();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: 'Manage Highlights', screen: UserBooksListScreen(), context: context),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: _store
                    .collection('kindle')
                    .document(Provider.of<AppData>(context).userData.id)
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
                    highlights = snapshot.data['highlights'];



                  for (var index = 0; index < highlights.length; index++) {
                      
                      final highlightWidget =
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Card(
                              color: Color.fromRGBO(250, 249, 242, 1),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomHighlightTile(
                                    icon: Icon(CustomIcons.circle, size: 8.0, color: HexColor(highlights[index]['color'])),
                                    text: highlights[index]['highlight'].replaceAll(new RegExp(r' - '), ''),

                                    popMenu: PopupMenuButton(
                                        onSelected: (selectedDropDownItem) =>
                                            handlePopUpMenuAction(
                                                selectedDropDownItem,
                                                context,
                                                index,
                                                highlights,
                                                widget.bookId
                                            ),
                                        itemBuilder: (BuildContext context) => _pop
                                    ),
                                    )
                                ],
                              ),
                            ),
                        );

                      widgetHighlights.add(highlightWidget);
                    }


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
void handlePopUpMenuAction(String value, BuildContext context, int index, List highlyObj, String bookName) {

  //Saving the data here so it can be easily manipulated and saved back in
  //Firebase database store -----DONT KNOW ANY BETTER WAY TO DO THIS YET
  Provider.of<AppData>(context, listen: false).setBookSpecificHighlightObj(highlyObj);
  Provider.of<AppData>(context, listen: false).setBookName(bookName);
  Provider.of<AppData>(context, listen: false).setCategoryIndex(index);

  var intIndex =   Provider.of<AppData>(context, listen: false).categoryIndex;

  print(index);
  //Had to create a list of type List<dynamic inorder to enable it get deleted from firebase>
  var highlight = [];
  highlight.add(highlyObj[intIndex]);


  //TODO: Work on only saving data that is edited and not the whole array again.

  switch (value) {
    case 'Share':
      {
        ShareHighlight().share(context, highlyObj[intIndex]['highlight'].replaceAll(RegExp(r'-\s[A-Za-z]+\s\d+'), ''));
      }
      break;

    case 'Edit':
      {
        editHighlightDialog(
            context, highlyObj[index]['highlight'].replaceAll(new RegExp(r' - '), ''), index)
            .then((val){
          switch (Provider.of<AppData>(context, listen: false).whatActionButton) {
            case 'Save':
              {
                highlyObj[index]['highlight'] = Provider.of<AppData>(context, listen: false).savedString;
                Firestore.instance.collection("kindle")
                    .document(Provider.of<AppData>(context, listen: false).userData.id)
                    .collection("books")
                    .document(Provider.of<AppData>(context, listen: false).bookName)
                    .updateData({"highlights": highlyObj});
              }
              break;

            case 'Favourite':
              {

              }
              break;

            default:
              break;
          }

        });
      }
      break;

    case 'Delete':
      {

      //Provider.of<AppData>(context, listen: false).reduceNoOfHighlights(1);
      Firestore.instance.collection("kindle")
            .document(Provider.of<AppData>(context, listen: false).userData.id)
            .collection("books")
            .document(Provider.of<AppData>(context, listen: false).bookName)
            .updateData({'highlights' : FieldValue.arrayRemove(highlight)});

      }
      break;

    case 'Categorise':
      {


        Navigator.popAndPushNamed(context, CategoryRoute );

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


Future<bool> editHighlightDialog(BuildContext context, String highlight, int index){

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
                Provider.of<AppData>(context, listen: false).setWhatActionButton('Save');
                Provider.of<AppData>(context, listen: false).setSavedHighlight(_highlightController.text);

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
          ],
        );
      }
  );

}

