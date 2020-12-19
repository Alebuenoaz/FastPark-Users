import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewID;
  final String parkingID;
  final String userID;
  final String value;

  Review({this.reviewID, this.parkingID, this.userID, this.value});

  Map<String, dynamic> toMap() {
    return {
      'parkingID': parkingID,
      'userID': userID,
      'value': value,
    };
  }

  factory Review.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> firestore = documentSnapshot.data;
    return Review(
      reviewID: documentSnapshot.documentID,
      parkingID: firestore['parkingID'],
      userID: firestore['userID'],
      value: firestore['value'],
    );
  }
}
