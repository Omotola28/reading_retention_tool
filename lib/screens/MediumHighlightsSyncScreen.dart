import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/utils/manageHighlightsController.dart';


class MediumHighlightsSyncScreen extends StatefulWidget {

  final String payload; //Variable that hold success message

  MediumHighlightsSyncScreen(this.payload);

  @override
  _MediumHighlightsSyncScreenState createState() => _MediumHighlightsSyncScreenState();
}

class _MediumHighlightsSyncScreenState extends State<MediumHighlightsSyncScreen> {

  var message;
  var highlights = [];
  bool mediumData = false;
  final manageHighlight = new ManageHighlightsController();

  @override
  void initState() {
    super.initState();

    setState(() {
      message = widget.payload;
    });
  }

  Future<DocumentSnapshot> _getMediumHighlights() async {

    var data = await Firestore.instance
        .collection('medium')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .get();

    if(data.exists){
      setState(() {
        mediumData = true;
      });
    }
    else{
      setState(() {
        mediumData = false;
      });
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  header(headerText: 'Medium Highlights', context: context , screen: HomeScreen() ),
      body: SafeArea(
        child: FutureBuilder (
            future:  _getMediumHighlights(),
            builder: (context, snapshot) {
              List<Widget> widgetHighlights = [];

              if(mediumData)  {

                List highlights = snapshot.data['mediumHighlights'];

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
                                          highlights[index]['id'],
                                          'medium'
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
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data['mediumHighlights'].length == null ? 0 : snapshot.data['mediumHighlights'].length,
                itemBuilder: (context, index) {
                  return widgetHighlights[index];
                },
              );
            }
        ),
      )
    );
  }
}

