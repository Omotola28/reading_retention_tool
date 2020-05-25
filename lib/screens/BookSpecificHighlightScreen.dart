import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/utils/manageHighlightsController.dart';



class BookSpecificHighlightScreen extends StatefulWidget {
  final String bookId;


  BookSpecificHighlightScreen(this.bookId);


  @override
  _BookSpecificHighlightScreenState createState() =>
      _BookSpecificHighlightScreenState();
}

class _BookSpecificHighlightScreenState extends State<BookSpecificHighlightScreen> {
  final _store = Firestore.instance;
  var highlights = [];
  final manageHighlight = new ManageHighlightsController();
  bool userHasData = false;

  Future<DocumentSnapshot> _getKindleHighlights() async {
    var data =  await _store
        .collection('kindle')
        .document(Provider.of<AppData>(context).userData.id)
        .collection('books')
        .document(widget.bookId).get();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: 'Manage Highlights', screen: UserBooksListScreen(), context: context),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future:  _getKindleHighlights(),
                builder: (context, snapshot) {
                  List<Widget> widgetHighlights = [];
                  if(userHasData){
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
                                        manageHighlight.handlePopUpMenuAction(
                                            selectedDropDownItem,
                                            context,
                                            index,
                                            highlights,
                                            widget.bookId,
                                            'kindle'
                                        ),
                                    itemBuilder: (BuildContext context) => manageHighlight.popMenu
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                      widgetHighlights.add(highlightWidget);
                    }
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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



