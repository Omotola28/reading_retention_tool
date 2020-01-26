import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/CategoryScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

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
                    highlights = snapshot.data['highlights'];

                    for (var highly in highlights) {

                      final highlightWidget =
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Card(
                              color: Color.fromRGBO(250, 249, 242, 1),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    //contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                                    contentPadding: EdgeInsets.all(20.0),
                                    subtitle: Text(
                                        highly['highlight'].replaceAll(new RegExp(r' - '), ''),
                                        style: TextStyle(color: kDarkColorBlack),
                                    ),


                                    leading: Icon(CustomIcons.circle, size: 10.0, color: HexColor(highly['color']),),
                                    trailing: PopupMenuButton(
                                        onSelected: (selectedDropDownItem) =>
                                            handlePopUpMenuAction(
                                                selectedDropDownItem,
                                                context,
                                                highly['index'],
                                                highlights,
                                                widget.bookId
                                            ),
                                        itemBuilder: (BuildContext context) => _pop
                                    ),

                                  ),
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
void handlePopUpMenuAction(String value, BuildContext context, String index, List highlyObj, String bookName) {

  //Saving the data here so it can be easily manipulated and saved back in
  //Firebase database store -----DONT KNOW ANY BETTER WAY TO DO THIS YET
  Provider.of<AppData>(context).setBookSpecificHighlightObj(highlyObj);
  Provider.of<AppData>(context).setBookName(bookName);
  Provider.of<AppData>(context).setCategoryIndex(index);

  var intIndex =   Provider.of<AppData>(context).categoryIndex;
  var highlightObj =  Provider.of<AppData>(context).bookSpecificHighlights;
  var highlight = highlightObj[intIndex - 1];

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

        Provider.of<AppData>(context).deleteBookSpecificHighlight(highlight);

        Firestore.instance.collection("users")
            .document(Provider.of<AppData>(context).uid)
            .collection("books")
            .document(Provider.of<AppData>(context).bookName)
            .updateData({"highlights": highlightObj});

      }
      break;

    case 'Categorise':
      {


        Navigator.popAndPushNamed(context, CategoryScreen.id, );

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
