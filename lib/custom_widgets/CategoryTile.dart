import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'dart:async';



class CategoryTile extends StatefulWidget {
  final String categoryTitle;
  final Color categoryColor;
  final String whichService;


  CategoryTile({this.categoryTitle, this.categoryColor, this.whichService});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {

  final _store = Firestore.instance;
  var highlight = [];


  var catHighlightObj = []; //Get a list og highlights that are in the category list

  var snackBar;


  Future<bool> _removeFromCategoryList(categoryDocId, highlightId) async {

    print(categoryDocId);
    print(highlightId);

    var getCategoryData = await _store.collection('category')
                          .document(Provider.of<AppData>(context, listen: false).userData.id)
                          .collection('userCategories')
                          .document(categoryDocId).get();

    if(getCategoryData.exists){
        getCategoryData.data['categoryHighlights'].forEach((item) {
          if(item['id'] == highlightId){
            setState(() {
              catHighlightObj.add(item);
            });
          }

      });

        await Firestore.instance.collection("category")
            .document(Provider.of<AppData>(context, listen: false).userData.id)
            .collection("userCategories")
            .document(categoryDocId)
            .updateData({'categoryHighlights':FieldValue.arrayRemove(catHighlightObj)});

        return true;
    }


  }

  Future<bool> _addtoCategory(category, data, highlightId) async{
    var catergoryData = [];
    var highlightExsist =[];

    var getCategoryData = await _store.collection('category')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .collection('userCategories')
        .document(category).get();


    if(getCategoryData.exists) {

      if (getCategoryData.data.length == 0) {
        catergoryData.add({'highlight': data, 'id' : highlightId});
      }
      else if (getCategoryData.data.length > 0) {

        highlightExsist.add({'highlight': data, 'id' : highlightId});
        catergoryData.add({'highlight': data, 'id' : highlightId});

        for(final highly in  getCategoryData.data['categoryHighlights']) {
          if(highly['id'] != highlightExsist[0]['id']){
            catergoryData.add(highly);
          }
        }
      }
    }


    _store.collection("category")
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .collection('userCategories')
        .document(category)
        .setData({'categoryHighlights' : catergoryData});

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var highlightObj = Provider.of<AppData>(context).bookSpecificHighlights;
    var index = Provider.of<AppData>(context).categoryIndex;


    return ListTile(
       leading:  Padding(
         padding: const EdgeInsets.only(top: 6.0),
         child: Icon(
           CustomIcons.circle,
           color: widget.categoryColor,
           size: 10.0,
         ),
       ),
      title: Text(widget.categoryTitle.toLowerCase()),

      onTap: (){

        //Scaffold.of(context).showSnackBar(snackBar);

       String colorString = widget.categoryColor.toString(); //Gets the Colour Obj as a string
       String colorHex = colorString.split('(0xff')[1].split(')')[0];


       if(highlightObj[index]['category'] != 'uncategorised' &&  highlightObj[index]['color'] != '#808080' ){

            //params categoryDocID and HighlightID
            _removeFromCategoryList(highlightObj[index]['category']+highlightObj[index]['color'], highlightObj[index]['id']).then((val){
                  print(val);

            });


       }

       highlightObj[index]['category'] = widget.categoryTitle;
       highlightObj[index]['color'] = '#'+colorHex;



       if(widget.whichService == 'kindle'){
         //Saving the whole obj back to firebase datastore after adding category.
         _store.collection("kindle")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .collection("books")
             .document(Provider.of<AppData>(context, listen: false).bookName)
             .updateData({"highlights": highlightObj});

         _addtoCategory(widget.categoryTitle+'#'+colorHex,
                        highlightObj[index]['highlight'],
                        highlightObj[index]['id']).then((isadded){
           if(isadded){
             Navigator.pop(context);
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context)
               => BookSpecificHighlightScreen(Provider.of<AppData>(context, listen: false).bookName)
               ),
             );
           }
         });


       }
       else if(widget.whichService == 'medium'){
         Firestore.instance.collection("medium")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .updateData({"mediumHighlights": highlightObj});

         _addtoCategory(widget.categoryTitle+'#'+colorHex,
                        highlightObj[index]['highlight'],
                        highlightObj[index]['id']).then((isadded){
           if(isadded){

             Navigator.popAndPushNamed(context, MediumHighlightsSyncRoute, arguments: 'success');
           }
         });
         


       }
       else if(widget.whichService == 'instapaper'){


         Firestore.instance.collection("instapaperhighlights")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .collection('highlights')
             .document(highlightObj[index]['bookmarkId'].toString())
             .updateData({"instaHighlights": highlightObj});

         _addtoCategory(widget.categoryTitle+'#'+colorHex,
                        highlightObj[index]['highlight'],
                        highlightObj[index]['id']).then((isadded){
           if(isadded){

             Navigator.popAndPushNamed(context, BookmarkHighlightRoute, arguments:highlightObj[index]['bookmarkId'].toString());
           }
         });


       }
       else if(widget.whichService == 'hmq'){
         //Saving the whole obj back to firebase datastore after adding category.
         _store.collection("hmq")
             .document(Provider.of<AppData>(context, listen: false).userData.id)
             .collection("books")
             .document(Provider.of<AppData>(context, listen: false).bookName)
             .updateData({"textList": highlightObj});

         _addtoCategory(widget.categoryTitle+'#'+colorHex,
             highlightObj[index]['highlight'],
             highlightObj[index]['id']).then((isadded){
           if(isadded){

             Navigator.popAndPushNamed(context, SpecificManualBookRoute,
                                       arguments: Provider.of<AppData>(context, listen: false).bookData);

           }
         });


       }
      },
    );
  }
}
