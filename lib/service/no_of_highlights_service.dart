import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class NoOfHighlightService {
  static Future<DocumentSnapshot> getNoOfHiglights() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    final noOfHighlightsAdded =
    Firestore.instance
        .collection("highlightsNo")
        .document(firebaseUser.uid)
        .get();

    return noOfHighlightsAdded;
    }

}