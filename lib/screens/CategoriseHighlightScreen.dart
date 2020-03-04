import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/CategoryTile.dart';
import 'package:reading_retention_tool/custom_widgets/AddCategoryWidget.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'package:reading_retention_tool/screens/BookmarkHighlightScreen.dart';
import 'package:reading_retention_tool/screens/MediumHighlightsSyncScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class CategoriseHighlightScreen extends StatefulWidget {

  final String whichService;

  CategoriseHighlightScreen(this.whichService);


  @override
  _CategoriseHighlightScreenState createState() => _CategoriseHighlightScreenState();
}

class _CategoriseHighlightScreenState extends State<CategoriseHighlightScreen> {
  dynamic backScreen;

  @override
  Widget build(BuildContext context) {

    if(widget.whichService == 'kindle'){
      backScreen = BookSpecificHighlightScreen(Provider.of<AppData>(context, listen: false).bookName);
    }
    else if(widget.whichService == 'medium'){
      backScreen = MediumHighlightsSyncScreen('success');
    }
    else{
      backScreen = BookmarkHighlightScreen(Provider.of<AppData>(context, listen: false).bookmarkID);//Add bookmark id
    }

    return Scaffold(
      appBar: header(headerText: 'Categorise Highlight', context: context, screen: backScreen ),
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
                                categoryColor: HexColor(snapshot.data.documents[index].documentID.split('#')[1]),
                                whichService:  widget.whichService,
                            );
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

