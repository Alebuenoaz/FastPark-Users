import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  final String documentID;
  final String description;
  final String direction;
  final String days;
  final String startTime;
  final String endTime;
  final String img;
  final double pricePerHour;
  final int contactNumber;
  final int userID;

  Parking(
      {this.description,
      this.direction,
      this.days,
      this.startTime,
      this.endTime,
      this.img,
      this.pricePerHour,
      this.contactNumber,
      this.userID,
      this.documentID});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'direction': direction,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
      'img': img,
      'pricePerHour': pricePerHour,
      'contactNumber': contactNumber,
      'userID': userID,
      'documentID': documentID,
    };
  }

  /*Parking.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        description = snapshot['Descripcion'],
        direction = snapshot['Direccion'],
        days = snapshot['Dias'],
        startTime = snapshot['HoraInicio'],
        endTime = snapshot['HoraCierre'],
        img = snapshot['Imagen'],
        pricePerHour = snapshot['TarifaPorHora'],
        contactNumber = snapshot['Telefono'];*/

  factory Parking.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> firestore = documentSnapshot.data;
    return Parking(
      description: firestore['description'],
      direction: firestore['direction'],
      days: firestore['days'],
      startTime: firestore['startTime'],
      endTime: firestore['endTime'],
      img: firestore['img'],
      pricePerHour: firestore['pricePerHour'],
      contactNumber: firestore['contactNumber'],
      userID: firestore['userID'],
      documentID: firestore['documentID'],
    );
  }
}
