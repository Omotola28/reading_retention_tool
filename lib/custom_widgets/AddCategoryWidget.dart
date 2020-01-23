import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class AddCategoryWidget extends StatefulWidget {
  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {

  String colCat;
  String newCategory;
/*  bool _colPink = false;
  bool _colYellow = false;
  bool _colGreen = false;
  bool _colPurple = false;
  bool _colGrey = false;
  bool _colCyan = false;
  bool _colDeepOrange = false;
  bool _amber = false;
  bool _colLightGreen = false;
  bool _colLime = false;
  bool _colBlueAccent = false;
  bool _colBrown = false;
  bool _colDeepPurpleAccent = false;*/

  Map<String, bool> checkVals = {
    '#ff0000' : false,
    '#ec8c9d' : false,
    '#ffdb00' : false,
    '#008000' : false,
    '#800080' : false,
    '#808080' : false,
    '#00ffff' : false,
    '#ffa500' : false,
    '#e3c64e' : false,
    '#90ee90' : false,
    '#00ff00' : false,
    '#0000ff' : false,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Color(0xff757575),
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Add Category',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kDarkColorBlack,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      cursorColor: kPrimaryColor,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
                      ),
                      onChanged: (newText){
                        newCategory = newText;
                      } ,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top : 20.0, bottom: 10.0),
                      child: TextAndDivider(),
                    ),

                   //Shows the list of colours
                   Wrap(
                     children: checkVals.keys.map((String key){
                        return colorCircle(context, key, HexColor(key));
                     }).toList(),
                   ),

                    Padding(padding: EdgeInsets.all(10)),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: kPrimaryColor,
                            ),
                          ),
                          onPressed: () {
                              Provider.of<AppData>(context).addCategory( newCategory, colCat);
                              Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: kPrimaryColor
                              ),
                            ),
                            onPressed: null,

                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget colorCircle(BuildContext context, String key, Color color) {


    var checked = [];
    var keyIndex;

    //TODO: This moves forward but it does come back which is sad! Not sure how to do this now
    getItems(){

      checkVals.forEach((key, value) {
        if(value == true)
        {

          checked.add(key);
          if(checked.length > 1)
          {
            keyIndex = checked[0];
            print(keyIndex);
            checkVals[keyIndex] = false;
            checked.removeAt(0);
          }

        }
      });


      // Clear array after use.
     // holder_1.clear();
    }



    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(50.0))
        ),
        child: Theme(
          //Gives it the same color as container when its not selected as well
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: color,
          ),
          child: Checkbox(
            activeColor: color,
            focusColor: color,
            value: checkVals[key],
            onChanged: (bool value) {
              setState(() {
                checkVals[key] = value;
                colCat = key;
              });
              getItems();
            },


          ),
        ),
      ),
    );
  }
}

class TextAndDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('Colors', style: TextStyle(color: kHighlightColorDarkGrey),)),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
                thickness: 1.5,
            ),
        ),

        ],
      );
  }
}
