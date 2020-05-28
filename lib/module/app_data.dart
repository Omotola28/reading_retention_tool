import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'package:reading_retention_tool/service/firestore_notification_service.dart';
import 'package:reading_retention_tool/plugins/highlightNotificationPlugin.dart';
import 'package:reading_retention_tool/module/user.dart';
import 'package:reading_retention_tool/service/no_of_highlights_service.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';


class AppData extends ChangeNotifier{

  String highlightId;
  String bookmarkId;
  String savedString;
  String whatActionButton;
  String bookName;
  int categoryIndex;
  List bookSpecificHighlights = [];
  int noOfHlightsAdded = 0;
  List notificationHighlights = [];
  String payloadHighlight;
  User userData;
  bool isCustomSignIn = false;
  Map<String, dynamic> bookData;


  List<NotificationData> _notifications = List();
  HighlightNotificationPlugin _notificationPlugin = HighlightNotificationPlugin();

  final _notificationsController = BehaviorSubject<List<NotificationData>>();
  Function(List<NotificationData>) get _inNotifications => _notificationsController.sink.add;
  Stream<List<NotificationData>> get outNotifications => _notificationsController.stream;


  setUserData(User data){
    userData = data;
    notifyListeners();
  }


  void setBookmarkIdentifier(String bookmarkIdentifier){
    bookmarkId = bookmarkIdentifier;
    notifyListeners();
  }

  void setHighlightIdentifier(String highlightIdentifier){
    highlightId = highlightIdentifier;
    notifyListeners();
  }

  void setWhatActionButton (String buttonName) {
    whatActionButton = buttonName;
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

    //No of highlights Added

    final noOfHighlights = await NoOfHighlightService.getNoOfHiglights();
    setNoOfHighlightsPerUser(noOfHighlights.data == null ? 0 : noOfHighlights.data ['number']);


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


///Number of highlights for each user
void setNoOfHighlightsPerUser(int number){
    noOfHlightsAdded += number;
    notifyListeners();
}

void reduceNoOfHighlights(int number){
    noOfHlightsAdded -= number;
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
  void setCustomSignIn(bool value){
    isCustomSignIn = value;
    notifyListeners();
  }


  void setBookData(Map<String, dynamic> data){
    bookData = data;
    notifyListeners();
  }

}