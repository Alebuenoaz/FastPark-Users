import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/reserva.dart';
import 'package:fast_park/models/review.dart';
import 'package:fast_park/models/user.dart';
import 'package:fast_park/models/parking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServ {
  Firestore _db = Firestore.instance;

  Future<void> addUser(User users) {
    return _db
        .collection('usuarios')
        .document(users.userId)
        .setData(users.toMap());
  }

  Future<User> usuarioCreado(String userId) {
    return _db
        .collection('usuarios')
        .document(userId)
        .get()
        .then((snapshot) => User.fromFirestore(snapshot));
  }

  Stream<User> streamUser(String userId) {
    return _db
        .collection('usuarios')
        .document(userId)
        .snapshots()
        .map((snap) => User.fromFirestore(snap));
  }

  Future<void> updateUser(User user) {
    return _db
        .collection('usuarios')
        .document(user.userId)
        .updateData(user.toMap());
  }

  Future<Parking> getParking(String parkingID) {
    return _db
        .collection('RegistroParqueos')
        .document(parkingID)
        .get()
        .then((snapshot) => Parking.fromFirestore(snapshot));
  }

  Stream<List<Parking>> streamParking(FirebaseUser user) {
    return (user != null)
        ? _db
            .collection('RegistroParqueos')
            .where('userID', isEqualTo: user.uid)
            .snapshots()
            .map((snapshot) => snapshot.documents
                .map((document) => Parking.fromFirestore(document))
                .toList())
        : null;
    //.where('userID', isEqualTo: 'NOVCBpNesvQBkacicyBE16bavxZ2')
    //.snapshots();
    //return ref.snapshots().map((list) =>
    //    list.documents.map((doc) => Parking.fromFirestore(doc)).toList());
    //return ref.map((list) =>
    //    list.documents.map((doc) => Parking.fromFirestore(doc)).toList());
  }

  Stream<List<Review>> streamReview(String parkingId) {
    //Stream<List<Parking>> myParkings = streamParking(parkingId);
    return _db
        .collection('puntuaciones')
        .where('parkingID', isEqualTo: parkingId)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => Review.fromFirestore(document))
            .toList());
  }

  Stream<List<User>> streamUsers() {
    return _db.collection('usuarios').snapshots().map((snapshot) => snapshot
        .documents
        .map((document) => User.fromFirestore(document))
        .toList());
  }

  Stream<List<Reserva>> streamReservasOwner(String parkingID) {
    return _db
        .collection('Reservas')
        .where('IDParqueo', isEqualTo: parkingID)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => Reserva.fromFirestore(document))
            .toList());
  }

  Stream<List<Reserva>> streamReservasUser(FirebaseUser user) {
    return _db
        .collection('Reservas')
        .where('IDUsuario', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => Reserva.fromFirestore(document))
            .toList());
  }

  Future<void> updateReserva(Reserva reserva) {
    return _db
        .collection('Reservas')
        .document(reserva.idReserva)
        .updateData(reserva.toMap());
  }
}
