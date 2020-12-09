import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String documentID;
  String name;
  String lastname;
  String ci;
  String email;
  String img;

  User.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        name = snapshot['name'],
        lastname = snapshot['lastname'],
        ci = snapshot['ci'],
        email = snapshot['email'],
        img = snapshot['img'];
}
