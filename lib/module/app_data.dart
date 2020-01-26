import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/module/category.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';

class AppData extends ChangeNotifier{

  DocumentSnapshot highlights;
  String email;
  String uid;
  String savedString;
  String whatActionButton;
  List highlightObject = [];
  String bookName;
  String mediumUsername;
  String selectedCat;
  Color selectedCol;
  int categoryIndex;
  List bookSpecificHighlights = [];

  List<Category> categories = [
    Category(categoryName: 'Self Help', defaultColor: Colors.blueAccent),
  ];

  void setCurrentUserEmail (String currentEmail){
      email = currentEmail;
      notifyListeners();
  }

  void setCurrentUid (String currentUID){
    uid = currentUID;
    notifyListeners();
  }

  void setWhatActionButton (String buttonName) {
    whatActionButton = buttonName;
    notifyListeners();
  }

  void setUploadedHighlights(DocumentSnapshot currentHighlights)
  {
    highlights = currentHighlights;
    notifyListeners();
  }

  void setHighlightListObject(List obj)
  {
    highlightObject = obj;
    notifyListeners();
  }

  void setSavedHighlight( String savedHighlight)
  {
    savedString = savedHighlight;
    notifyListeners();

  }

  void setBookName(String fileName)
  {
    bookName = fileName;
    notifyListeners();
  }

  void setMeduimUserName(String username){
    mediumUsername = username;
    notifyListeners();
  }

  void addCategory(String categoryName, String color){

    var col = HexColor(color == null ? '#000000' : color);

    final category = new Category(categoryName: categoryName, defaultColor: col);
    categories.add(category);
    notifyListeners();
  }

  void setCategory(String cat, Color color)
  {
    selectedCat = cat;
    selectedCol = color;
    notifyListeners();
  }

  void setCategoryIndex(String index){
     categoryIndex = int.parse(index);
     notifyListeners();
  }


///The function would help store list object that can be manipulated and saved in database

void setBookSpecificHighlightObj(List obj){
    bookSpecificHighlights = obj;
    notifyListeners();

}

///Delete category screen off the book specific category screen
void deleteBookSpecificHighlight(Object value){
    bookSpecificHighlights.remove(value);

    notifyListeners();
}

}