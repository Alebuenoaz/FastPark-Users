import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String name;
  String documentID;

  User.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        name = snapshot['name'],
        email = snapshot['email'];
}
