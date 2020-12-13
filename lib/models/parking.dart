import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  String documentID;
  String idParkingManager;
  String description;
  String direction;
  String days;
  String startTime;
  String endTime;
  String img;
  double pricePerHour;
  int contactNumber;

  Parking.fromSnapshot(DocumentSnapshot snapshot)
      : documentID = snapshot.documentID,
        idParkingManager = snapshot['IDManager'],
        description = snapshot['Descripcion'],
        direction = snapshot['Direccion'],
        days = snapshot['Dias'],
        startTime = snapshot['HoraInicio'],
        endTime = snapshot['HoraCierre'],
        img = snapshot['Imagen'],
        pricePerHour = snapshot['TarifaPorHora'],
        contactNumber = snapshot['Telefono'];
}
