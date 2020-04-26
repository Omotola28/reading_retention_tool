import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'dart:async';


class FirestoreNotificationService {
  static Future<Stream<QuerySnapshot>> getAllNotifications() async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    final notificationCollectionStream =
      Firestore.instance
          .collection("notifications")
          .document(firebaseUser.uid)
          .collection("userNotifications")
          .snapshots();

    return notificationCollectionStream;
  }

  static Future<void> addNotification(List<NotificationData> notifications) async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    for(final notification in notifications){
     Firestore.instance
          .collection("notifications")
          .document(firebaseUser.uid)
          .collection("userNotifications")
          .document(notification.notificationIdString)
          .setData(notification.toJson());
    }

  }

  static Future<void> removeNotification(NotificationData notification) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    
      Firestore.instance
        .collection("notifications")
        .document(firebaseUser.uid)
        .collection("userNotifications")
        .document(notification.notificationIdString)
        .delete();
  }
}