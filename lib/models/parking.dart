import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  final String documentID;
  final String description;
  final String direction;
  final String days;
  final String startTime;
  final String endTime;
  final String img;
  final String idParkingManager;
  final double pricePerHour;
  final int contactNumber;
  final int userID;
  final int ownerID;
  final String name;
  final String lat;
  final String lng;

  Parking({
    this.idParkingManager,
    this.description,
    this.direction,
    this.days,
    this.startTime,
    this.endTime,
    this.img,
    this.pricePerHour,
    this.contactNumber,
    this.userID,
    this.documentID,
    this.ownerID,
    this.name,
    this.lat,
    this.lng,
  });

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
      documentID: documentSnapshot.documentID,
      idParkingManager: documentSnapshot['IDManager'],
      description: documentSnapshot['Descripcion'],
      direction: documentSnapshot['Direccion'],
      days: documentSnapshot['Dias'],
      startTime: documentSnapshot['HoraInicio'],
      endTime: documentSnapshot['HoraCierre'],
      img: documentSnapshot['Imagen'],
      pricePerHour: documentSnapshot['TarifaPorHora'],
      contactNumber: documentSnapshot['Telefono'],
      userID: documentSnapshot['CIPropio'],
      ownerID: documentSnapshot['CIPropietario'],
      name: documentSnapshot['Nombre'],
      lat: documentSnapshot['lat'],
      lng: documentSnapshot['lng'],
    );
  }
}
