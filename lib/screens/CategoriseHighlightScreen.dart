import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/CategoryTile.dart';
import 'package:reading_retention_tool/custom_widgets/AddCategoryWidget.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class CategoriseHighlightScreen extends StatefulWidget {

  @override
  _CategoriseHighlightScreenState createState() => _CategoriseHighlightScreenState();
}

class _CategoriseHighlightScreenState extends State<CategoriseHighlightScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: header(headerText: 'Categorise Highlight', context: context, screen: UserBooksListScreen()),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: kLightYellowBG,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('category')
                        .document(Provider.of<AppData>(context).userData.id)
                        .collection('userCategories').snapshots(),
                    builder: (context, snapshot){

                      if(snapshot.hasData){
                        return ListView.builder(
                          itemBuilder: (context, index) {

                            ///Tap tile to add category to highlight
                            return CategoryTile(
                                categoryTitle: snapshot.data.documents[index].documentID.split('#')[0],
                                categoryColor: HexColor(snapshot.data.documents[index].documentID.split('#')[1]));
                          },
                          itemCount: snapshot.data.documents.length,
                        );

                      }
                      return Center(child: Text('Start adding data', style: TextStyle(color: Colors.black)));


                    }

                ),
              ),
              FlatButton.icon(
                color: Colors.white,
                icon: Icon(Icons.add), //`Icon` to display
                label: Text('Add category'), //`Text` to display
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => AddCategoryWidget());
                  //showCategoryDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

