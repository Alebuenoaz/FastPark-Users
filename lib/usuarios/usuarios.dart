import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String nombre;
  final String apellido;
  final String ci;
  final String email;
  final String img;

  User(
      {this.userId, this.nombre, this.apellido, this.ci, this.email, this.img});

  Map<String, dynamic> toMap() {
    return {
      //'userId': userId,
      'nombre': nombre,
      'apellido': apellido,
      'ci': ci,
      'email': email,
      'img': img
    };
  }

  factory User.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> firestore = documentSnapshot.data;
    return User(
      userId: documentSnapshot.documentID,
      nombre: firestore['nombre'],
      apellido: firestore['apellido'],
      ci: firestore['ci'],
      email: firestore['email'],
      img: firestore['img'],
    );
  }
}
