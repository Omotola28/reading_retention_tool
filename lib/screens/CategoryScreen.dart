import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/CategoryTile.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/custom_widgets/AddCategoryWidget.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';

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
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CategoryTile(
                          categoryTitle: Provider.of<AppData>(context)
                              .categories[index]
                              .categoryName,
                          categoryColor: Provider.of<AppData>(context)
                              .categories[index]
                              .defaultColor);
                    },
                    itemCount: Provider.of<AppData>(context).categories.length,
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

/*
showCategoryDialog(BuildContext context) {
  //final _highlightController = TextEditingController(text: highlight);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: TextFormField(
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 3.0)),
              ),
              maxLines: null,
              //controller: _highlightController,
              //showing save button for all the tiles
              onTap: () {
                //something(obj[index].replaceAll(new RegExp(r' - '), ''));
              }),
          actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 15.0, color: kDarkColorBlack),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                //print(_highlightController.text);
              },
            ),
            FlatButton(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                */
/* ... *//*

              },
            ),
          ],
        );
      });
}
*/
