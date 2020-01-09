import 'package:flutter/foundation.dart';


class UserData extends ChangeNotifier{
  String email;
  String uid;

  void setCurrentUserEmail (String currentEmail){
      email = currentEmail;
      notifyListeners();
  }

  void setCurrentUid (String currentUID){
    uid = currentUID;
    notifyListeners();
  }

}