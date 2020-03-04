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
  String bookmarkID;
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
  bool bookmarkIsSynced = false;

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

  void setBookMarkIdentifier(String bookmarkIdentifier){
    bookmarkID = bookmarkIdentifier;
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

void setSpecificHighlightObj(List obj){
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

void setBookmarkIsSynced(bool isSynced) {
  bookmarkIsSynced = isSynced;
  notifyListeners();
}


///Set the add list of highlights to firestore service
  Future<void> addNotification(List<NotificationData> notifications) async {

    List<NotificationData> notificationData = [];
    //Remove notifications that have already been created before
    var toRemove = [];

    var id;

    for(final notification in notifications){
       var notificationExsist =  await  _checkIfIdExists(notification.notificationIdString);
       if(!notificationExsist){//If notifications does not exist increment the id
          _checkNoOfHighlights().then((no){
            no == 0 ? id = 0 : id = no;
            for(final notification in notifications){
              notificationData.removeWhere( (e) => toRemove.contains(e));
              notification.notificationId = id++;
              notificationData.add(notification);
              continue;
            }
            FirestoreNotificationService.addNotification(notificationData);

          });

       }
       else{
         //Remove it from the list of notifications that is currently being set
         toRemove.add(notification);
       }
    }

  }


  Future<bool> _checkIfIdExists(String id) async {

    final snapShot = await Firestore.instance
        .collection('notifications')
        .document(userData.id) //Should already be set when user signs in
        .collection('userNotifications')
        .document(id)
        .get();

    return snapShot.exists;

  }

  Future<int> _checkNoOfHighlights() async{

     final snapShot = await Firestore.instance
        .collection('notifications')
        .document(userData.id) //Should already be set when user signs in
        .collection('userNotifications')
        .getDocuments();

     return snapShot.documents.length;
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