import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/CategoryTile.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/custom_widgets/AddCategoryWidget.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class CategoryScreen extends StatefulWidget {
  static String id = 'category_screen';


  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
              Navigator.popAndPushNamed(context, HomeScreen.id);
            }),
        title: Text(
          'Categorise Highlight',
          style: TextStyle(
            color: kDarkSocialBtnColor,
            fontSize: 18.0,
          ),
        ),
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
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
                    stream: Firestore.instance.collection('users')
                        .document(Provider.of<AppData>(context).uid)
                        .collection('categories').snapshots(),
                    builder: (context, snapshot){
                      List<ListTile> categoryList = [];
                      if(snapshot.hasData){


                        return ListView.builder(
                          itemBuilder: (context, index) {

                            //return Text(snapshot.data.documents[index].documentID.split('#')[0]);
                            return CategoryTile(
                                categoryTitle: snapshot.data.documents[index].documentID.split('#')[0],
                                categoryColor: HexColor(snapshot.data.documents[index].documentID.split('#')[1]));
                          },
                          itemCount: snapshot.data.documents.length,
                        );

                      }
                      else{

                        return Text('Start adding data', style: TextStyle(color: Colors.black));
                      }


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

