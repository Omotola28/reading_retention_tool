import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class ManageCategory extends StatefulWidget {
  @override
  _ManageCategoryState createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {

  void removeCategory(String categoryId, BuildContext context){

    Firestore.instance
        .collection("category")
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .collection("userCategories")
        .document(categoryId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: 'Manage Category', screen: HomeScreen(), context: context),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                  flex: 4,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('category')
                          .document(Provider.of<AppData>(context, listen: false).userData.id)
                          .collection('userCategories').snapshots(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: BoxDecoration(border: new Border.all(
                                      width:0.5, color: Colors.grey),
                                      color: kLightYellowBG),
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Icon(
                                        CustomIcons.circle,
                                        color: HexColor(snapshot.data.documents[index].documentID.split('#')[1]),
                                        size: 10.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    title: Text(
                                      snapshot.data.documents[index].documentID.split('#')[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kDarkColorBlack),
                                    ),
                                    subtitle: snapshot.data.documents[index].data['categoryHighlights'] == null ?
                                              Text('0') : Text(snapshot.data.documents[index].data['categoryHighlights'].length.toString()),
                                    trailing: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child:  IconButton(
                                        onPressed: () => this.removeCategory(snapshot.data.documents[index].documentID, context),
                                        icon: Icon(Icons.delete, size: 20),
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.popAndPushNamed(context, ShowRetrievedHightlightsRoute, arguments: snapshot.data.documents[index].documentID);
                                    },

                                  )
                              );
                            },
                            itemCount: snapshot.data.documents.length,
                          );

                        }
                        return Text('No categories yet', style: TextStyle(color: Colors.black));
                      }

                  )
              ),
            ],
          )

      ),
    );
  }
}


