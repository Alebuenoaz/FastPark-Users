import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/review.dart';
import 'package:fast_park/models/usuarios.dart';
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

  Stream<List<Parking>> streamParking(FirebaseUser user) {
    return _db
        .collection('RegistroParqueos')
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => Parking.fromFirestore(document))
            .toList());
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
}
