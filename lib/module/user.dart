import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String  id;
  String username;
  String email;
  String displayName;
  String photoUrl;
  String bio;
  String password;

  User({
    this.id,
    this.username,
    this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.password
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User (
      id : doc['id'],
      email : doc['email'],
      username: doc['username'],
      displayName: doc['displayname'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      password: doc['password']
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'email': this.email,
      'username': this.username,
      'displayName' : this.displayName,
      'photoUrl': this.photoUrl,
      'bio' : this.bio,
    };
  }


}

