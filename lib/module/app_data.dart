import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/module/category.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'package:reading_retention_tool/service/firestore_notification_service.dart';
import 'package:reading_retention_tool/plugins/highlightNotificationPlugin.dart';
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

  List<NotificationData> _notifications = List();
  HighlightNotificationPlugin _notificationPlugin = HighlightNotificationPlugin();

  final _notificationsController = BehaviorSubject<List<NotificationData>>();
  Function(List<NotificationData>) get _inNotifications => _notificationsController.sink.add;
  Stream<List<NotificationData>> get outNotifications => _notificationsController.stream;


  List<Category> categories = [];


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
  Future<void> addNotification(List<NotificationData> notifications, String docId) async {
    List<NotificationData> notificationData = [];
    int id = 0;
    for (var i = 0; i < 100; i++) {
      bool exists = _checkIfIdExists(_notifications, i);
      if (!exists) {
        id = i;
        break;
      }
    }

  // print(notifications);
    for(final notification in notifications){
       notification.notificationId = id++;
       notificationData.add(notification);
    }



   await FirestoreNotificationService.addNotification(notificationData, docId);
  }

  //TODO: Have to check for exsisting highlights in firestore but this might be tricky since
  //TODO: Its the ID we are using to check for duplicates but i dont know
  bool _checkIfIdExists(List<NotificationData> notifications, int id) {

    for (final notification in notifications) {
      if (notification.notificationId == id) {
        return true;
      }
    }
    return false;
  }

  ///Remove notifications from notifications list
  Future<void> removeNotification(NotificationData notification) async {
    await FirestoreNotificationService.removeNotification(notification);
  }


}