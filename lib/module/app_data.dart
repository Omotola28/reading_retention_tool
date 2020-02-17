import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/module/category.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'package:reading_retention_tool/service/firestore_notification_service.dart';
import 'package:reading_retention_tool/plugins/highlightNotificationPlugin.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';


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
  int noOfHighlights = 0;
  List notificationHighlights = [];
  String payloadHighlight;
  User userData;
  bool isCustomSignIn = false;

  List<NotificationData> _notifications = List();
  HighlightNotificationPlugin _notificationPlugin = HighlightNotificationPlugin();

  final _notificationsController = BehaviorSubject<List<NotificationData>>();
  Function(List<NotificationData>) get _inNotifications => _notificationsController.sink.add;
  Stream<List<NotificationData>> get outNotifications => _notificationsController.stream;


  List<Category> categories = [];

  setUserData(User data){
    userData = data;
    notifyListeners();
  }


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

    final category = Category(categoryName: categoryName, defaultColor: col);
    categories.add(category);
    notifyListeners();
  }

  void setCategory(String cat, Color color)
  {
    selectedCat = cat;
    selectedCol = color;
    notifyListeners();
  }

  void setCategoryIndex(int index){
     categoryIndex = index;
     notifyListeners();
  }

  Future<void> init() async {

    final notificationStream = await FirestoreNotificationService.getAllNotifications();

    notificationStream.listen((querySnapshot) {
      _notifications = querySnapshot.documents.map((doc) => NotificationData.fromDb(doc.data, doc.documentID)).toList();

      startNotifications(_notifications);
      _inNotifications(_notifications);
    });
  }

  Future<void> cancelNotifications() async {
    await _notificationPlugin.cancelAllNotifications();
  }

  Future<void> startNotifications(List<NotificationData> notifications) async {
    await _notificationPlugin.scheduleAllNotifications(notifications);
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

///Number of highlights for each user
void setNoOfHighlightsPerUser(int number){
    noOfHighlights += number;
    notifyListeners();
}

void reduceNoOfHighlights(int number){
    noOfHighlights -= number;
    notifyListeners();
}


///Set the add list of highlights to firestore service
  Future<void> addNotification(List<NotificationData> notifications) async {

    List<NotificationData> notificationData = [];
    int id = 0;

   /* for(final notification in notifications){
       var notificationExsist =  await  _checkIfIdExists(notification.notificationIdString);
       print(notificationExsist);

    }*/


    //Making sure that the notifications created increments according to how many notifications are stored
    // In the database
    var noOfNotifications = _checkIfIdExists();
    noOfNotifications.then((value){
      print(value);
       value == 0 ? id = 0 : id = value - 1;
    });

    for(final notification in notifications){
      print('ID $id');
      notification.notificationId = id++;
      notificationData.add(notification);
    }


    await FirestoreNotificationService.addNotification(notificationData);

    //Get a snapshot of all th notifications in the database and check for if the id is already there!
   /* List<NotificationData> notificationData = [];
    int id = 0;
    for (var i = 0; i < 100; i++) {
      bool exists = _checkIfIdExists(_notifications, i);
      if (!exists) {
        id = i;
        break;
      }
    }*/
  }

  //TODO: Have to check for exsisting highlights in firestore but this might be tricky since
  //TODO: Its the ID we are using to check for duplicates but i dont know
  Future<int> _checkIfIdExists() async{

    var noOfNotifications;

    final snapShot = Firestore.instance
        .collection('notifications')
        .document(userData.id) //Should already be set when user signs in
        .collection('userNotifications')
        .getDocuments();

    snapShot.then((value){
      print('CHECKING ${value.documents.length}');
      noOfNotifications = value.documents.length;
    });

    return noOfNotifications;

  }

  ///Remove notifications from notifications list
  Future<void> removeNotification(NotificationData notification) async {
    await FirestoreNotificationService.removeNotification(notification);
  }

  ///set custom sign in
  setCustomSignIn(bool value){
    isCustomSignIn = value;
    notifyListeners();
  }

}