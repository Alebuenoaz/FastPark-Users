import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  final String idReserva;
  final String idParqueo;
  final String idUsuario;
  final String horaFinal;
  final String horaInicio;
  final String tamAuto;
  final String placa;

  Reserva({
    this.idReserva,
    this.idUsuario,
    this.horaInicio,
    this.horaFinal,
    this.idParqueo,
    this.tamAuto,
    this.placa,
  });

  Map<String, dynamic> toMap() {
    return {
      'IDParqueo': idParqueo,
      'IDUsuario': idUsuario,
      'HoraInicio': horaInicio,
      'HoraFinal': horaFinal,
      'TamañoAuto': tamAuto,
      'Placa': placa,
    };
  }

  factory Reserva.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> firestore = documentSnapshot.data;
    return Reserva(
      idReserva: documentSnapshot.documentID,
      idParqueo: documentSnapshot['IDParqueo'],
      idUsuario: documentSnapshot['IDUsuario'],
      horaInicio: documentSnapshot['HoraInicio'],
      horaFinal: documentSnapshot['HoraFinal'],
      tamAuto: documentSnapshot['TamañoAuto'],
      placa: documentSnapshot['Placa'],
    );
  }
}
