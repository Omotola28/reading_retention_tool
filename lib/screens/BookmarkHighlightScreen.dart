import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/InstapaperBookmarkScreen.dart';
import 'package:reading_retention_tool/utils/manageHighlightsController.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class BookmarkHighlightScreen extends StatefulWidget {

  final String bookmarkId;

  BookmarkHighlightScreen(this.bookmarkId);

  @override
  _BookmarkHighlightScreenState createState() => _BookmarkHighlightScreenState();
}

class _BookmarkHighlightScreenState extends State<BookmarkHighlightScreen> {

  final _store = Firestore.instance;
  var highlights = [];
  var highlightData = false;
  var isBookMarkSynced;


  final manageHighlight = new ManageHighlightsController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<dynamic> _getInstapaperHighlights() {
    return this._memoizer.runOnce(() async {
    var data =  await _store
        .collection('instapaperhighlights')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .collection('highlights')
        .document(widget.bookmarkId)
        .get();


    if(data.exists){

      setState(() {
        highlightData = true;
      });
    }
    else{
      setState(() {
        highlightData = false;
      });
    }

    return data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: 'Bookmark Highlight', screen: InstapaperBookmarkScreen(), context: context),
      body: SafeArea(
        child: FutureBuilder (
            future:  _getInstapaperHighlights(),
            builder: (context, snapshot) {
              List<Widget> widgetHighlights = [];

              if(highlightData)  {

                List highlights = snapshot.data['instaHighlights'];

                if(highlights.isEmpty){
                  return Container(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'Images/notfound.png',
                            ),
                            Text('No Highlights For this Bookmark',
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
                              text: highlights[index]['highlight'],

                              popMenu: PopupMenuButton(
                                  onSelected: (selectedDropDownItem) =>
                                      manageHighlight.handlePopUpMenuAction(
                                          selectedDropDownItem,
                                          context,
                                          index,
                                          highlights,
                                          highlights[index]['id'].toString(),
                                          'instapaper'
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

              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 10.0,),
                      Text('This might take some time!',)
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data['instaHighlights'].length == null ? 0 : snapshot.data['instaHighlights'].length,
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


