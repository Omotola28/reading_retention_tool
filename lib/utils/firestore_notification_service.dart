import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';

class FirestoreNotificationService {
  static Future<Stream<QuerySnapshot>> getAllNotifications() async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    final notificationCollectionStream = Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection("notifications")
        .snapshots();
    return notificationCollectionStream;
  }

  static Future<void> addNotification(List<NotificationData> notifications, String docId) async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    for(final notification in notifications){
     Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("notifications")
          .document(docId+'-'+randomAlpha(5))
          .setData(notification.toJson());
    }


  }

 /* static Future<void> removeNotification(NotificationData notification) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection("notifications")
        .document(notification.id)
        .delete();
  }*/
}