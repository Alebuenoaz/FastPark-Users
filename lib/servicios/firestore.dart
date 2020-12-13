import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastpark/parqueos/parking.dart';
import 'package:fastpark/usuarios/usuarios.dart';
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
    var ref = _db.collection('RegistroParqueos');
    //.where('userID', isEqualTo: 'NOVCBpNesvQBkacicyBE16bavxZ2')
    //.snapshots();
    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Parking.fromFirestore(doc)).toList());
    //return ref.map((list) =>
    //    list.documents.map((doc) => Parking.fromFirestore(doc)).toList());
  }
}
