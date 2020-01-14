import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppData extends ChangeNotifier{

 // DocumentSnapshot highlights;
  String email;
  String uid;
  String savedString;
  String whatActionButton;
 // List highlightObject = [];

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

 /* void setUploadedHighlights(DocumentSnapshot currentHighlights)
  {
    highlights = currentHighlights;
    notifyListeners();
  }

  void setHighlightListObject(List obj)
  {
    highlightObject = obj;
    notifyListeners();
  }*/

  void setSavedHighlight( String savedHighlight)
  {
    savedString = savedHighlight;
    notifyListeners();

  }

}