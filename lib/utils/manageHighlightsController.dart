import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/utils/share.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/constants/constants.dart';


class ManageHighlightsController{

  static const _menuItems = <String>[
    'Share',
    'Edit',
    'Categorise',
    'Delete',
  ];

  //Shows the popup menu for each tile
  List<PopupMenuItem<String>> popMenu = _menuItems.map((String val) =>
      PopupMenuItem<String>(
        value: val,
        child: Text(val),
      )

  ).toList();

  /// When a [PopUpMenuItem] is selected, we perform the action here
  void handlePopUpMenuAction(String value, BuildContext context, int index, List highlyObj, String identifier, String whichServiceHighlight) {

    //Saving the data here so it can be easily manipulated and saved back in
    //Firebase database store -----DONT KNOW ANY BETTER WAY TO DO THIS YET
    Provider.of<AppData>(context, listen: false).setSpecificHighlightObj(highlyObj);
    Provider.of<AppData>(context, listen: false).setBookName(identifier); //Identifies what kindlebook, bookmark, medium we are deleting from
    Provider.of<AppData>(context, listen: false).setCategoryIndex(index);

    var intIndex =   Provider.of<AppData>(context, listen: false).categoryIndex;

    print(index);
    //Had to create a list of type List<dynamic inorder to enable it get deleted from firebase>
    var highlight = [];
    highlight.add(highlyObj[intIndex]);


    //TODO: Work on only saving data that is edited and not the whole array again.

    switch (value) {
      case 'Share':
        {
          //ShareHighlight().share(context, highlyObj[intIndex]['highlight'].replaceAll(RegExp(r'-\s[A-Za-z]+\s\d+'), ''));
          ShareHighlight().share(context, highlyObj[intIndex]['highlight']);

        }
        break;

      case 'Edit':
        {
          editHighlightDialog(
              context, highlyObj[index]['highlight'], index)
              .then((val){
            switch (Provider.of<AppData>(context, listen: false).whatActionButton) {
              case 'Save':
                {
                  highlyObj[index]['highlight'] = Provider.of<AppData>(context, listen: false).savedString;
                  //Save based on what data we are saving for kindle, higlight or what?
                  if(whichServiceHighlight == 'kindle'){

                       Firestore.instance.collection("kindle")
                          .document(Provider.of<AppData>(context, listen: false).userData.id)
                          .collection("books")
                          .document(Provider.of<AppData>(context, listen: false).bookName)
                          .updateData({"highlights": highlyObj});
                  }
                  else if(whichServiceHighlight == 'medium'){
                    Firestore.instance.collection("medium")
                        .document(Provider.of<AppData>(context, listen: false).userData.id)
                        .updateData({"mediumHighlights": highlyObj});

                  }
                  else if(whichServiceHighlight == 'instapaper'){

                    Firestore.instance.collection("instapaperhighlights")
                        .document(identifier)
                        .updateData({"instaHighlights": highlyObj});
                  }

                }
                break;

              case 'Favourite':
                {

                }
                break;

              default:
                break;
            }

          });
        }
        break;

      case 'Delete':
        {

          if(whichServiceHighlight == 'kindle'){
            Firestore.instance.collection("kindle")
                .document(Provider.of<AppData>(context, listen: false).userData.id)
                .collection("books")
                .document(Provider.of<AppData>(context, listen: false).bookName)
                .updateData({'highlights' : FieldValue.arrayRemove(highlight)});
          }
          else if(whichServiceHighlight == 'medium'){
            Firestore.instance.collection("medium")
                .document(Provider.of<AppData>(context, listen: false).userData.id)
                .updateData({"mediumHighlights":FieldValue.arrayRemove(highlight)});
          }
          else{
            Firestore.instance.collection("instapaperhighlights")
                .document(identifier)
                .updateData({"instaHighlights": FieldValue.arrayRemove(highlight)});
          }


        }
        break;

      case 'Categorise':
        {

          //Set identifier mostly for bookmarkID
          Provider.of<AppData>(context, listen: false).setBookMarkIdentifier(identifier);

          Navigator.popAndPushNamed(context, CategoryRoute, arguments: whichServiceHighlight );

        }
        break;

      default:
        {
          //statements;
        }
        break;
    }

    print(value);
  }


  Future<bool> editHighlightDialog(BuildContext context, String highlight, int index){

    final _highlightController = TextEditingController(text: highlight);
    //TODO: Inorder to update the list for the index when a tile is deleted we have to use set state
    return showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: TextFormField(

                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                maxLines: null,
                controller: _highlightController,
                //showing save button for all the tiles
                onTap: () {
                  //something(obj[index].replaceAll(new RegExp(r' - '), ''));
                }),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  CustomIcons.check,
                  color: kHighlightColorDarkGrey,
                ),
                onPressed: () {
                  Provider.of<AppData>(context, listen: false).setWhatActionButton('Save');
                  Provider.of<AppData>(context, listen: false).setSavedHighlight(_highlightController.text);

                  Navigator.of(context).pop(true);
                  //print(_highlightController.text);
                },
              ),
              FlatButton(
                child: Icon(
                  CustomIcons.heart,
                  color: kHighlightColorDarkGrey,
                ),
                onPressed: () {
                  Provider.of<AppData>(context).setWhatActionButton('Favourite');
                  Navigator.of(context).pop(true);
                  /* ... */
                },
              ),
            ],
          );
        }
    );

  }



}