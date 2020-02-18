import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/screens/CreateNotificationPage.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';

class CategoryHighlightsScreen extends StatefulWidget {


  final String categoryId;


  CategoryHighlightsScreen(this.categoryId);

  @override
  _CategoryHighlightsScreenState createState() => _CategoryHighlightsScreenState();
}

class _CategoryHighlightsScreenState extends State<CategoryHighlightsScreen> {

  List notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: '${widget.categoryId} highlights', context: context, screen: HomeScreen()),
      body: SafeArea(child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlineButton(
                      disabledBorderColor: kPrimaryColor,
                      onPressed: () {
                        //Navigator.pop(context);
                       // Navigator.pushNamed(context, WaitingToLoginRoute);
                       Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)
                                 => CreateNotificationPage(notifications, widget.categoryId)
                          ),
                        );

                      },
                      child: Text('Create Notification',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      letterSpacing: 1
                                  ),
                      ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance.collection('kindle')
                                                .document(Provider.of<AppData>(context).userData.id)
                                                .collection('books').snapshots(),
                      builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<Widget> widgetHighlights = [];
                            final snaps = snapshot.data.documents;

                            for(var snap in snaps ){
                              for( var i = 0; i < snap.data['highlights'].length; i++){
                                if(snap.data['highlights'][i]['category'] == '${widget.categoryId}'){
                                   final catHighlight = Padding(
                                     padding: EdgeInsets.all(10.0),
                                     child: Card(
                                       color: Color.fromRGBO(250, 249, 242, 1),

                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: <Widget>[
                                           CustomHighlightTile(
                                               icon:Icon(CustomIcons.circle, size: 10.0, color: HexColor(snap.data['highlights'][i]['color']),) ,
                                                text : snap.data['highlights'][i]['highlight'].replaceAll(new RegExp(r' - '), '')),

                                         ],
                                       ),
                                     ),
                                   );

                                   widgetHighlights.add(catHighlight);
                                   notifications.add(
                                      { 'id' : snap.data['highlights'][i]['id'] ,
                                        'notification' : snap.data['highlights'][i]['highlight'].replaceAll(new RegExp(r' - '), '')
                                      }
                                   );
                                }
                              }
                            }

                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: widgetHighlights.length == null ? 0 : widgetHighlights.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: widgetHighlights[index],
                                  );
                                });
                          }
                          return Column(
                              children: <Widget>[
                                Center(child:
                                Text('No highlights in this Category',
                                  style: TextStyle(
                                      color: kDarkColorBlack
                                  ),
                                ),
                                ),
                              ],
                            );
                      }

                  ),
                )
              ],
            ),
      ),
    )

    );
  }
}

