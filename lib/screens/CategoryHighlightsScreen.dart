import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/screens/CreateNotificationPage.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

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
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        title: Text(
          '${widget.categoryId} highlights'.toUpperCase(),
          style: TextStyle(
              color: kDarkSocialBtnColor,
              fontSize: 18.0
          ),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
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
      body: SafeArea(child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlineButton(
                      disabledBorderColor: kPrimaryColor,
                      onPressed: () {
                        //print(notifications);
                        Navigator.pop(context);
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
                      stream: Firestore.instance.collection('users')
                                                .document(Provider.of<AppData>(context).uid)
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
                                           ListTile(
                                             //contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                                             contentPadding: EdgeInsets.all(20.0),
                                             subtitle: Text(
                                               snap.data['highlights'][i]['highlight'].replaceAll(new RegExp(r' - '), ''),
                                               style: TextStyle(color: kDarkColorBlack),
                                             ),

                                             leading: Icon(CustomIcons.circle, size: 10.0, color: HexColor(snap.data['highlights'][i]['color']),),
                                           ),
                                         ],
                                       ),
                                     ),
                                   );

                                   widgetHighlights.add(catHighlight);
                                   notifications.add(snap.data['highlights'][i]['highlight'].replaceAll(new RegExp(r' - '), ''));

                                }
                                //print(snap.data['highlights'][i]['category']);
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
