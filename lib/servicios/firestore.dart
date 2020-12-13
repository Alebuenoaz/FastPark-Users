import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastpark/usuarios/usuarios.dart';

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

  /*Stream<User> streamParking(String userId) {
    return _db
        .collection('parqueos')
        .document(userId)
        .snapshots()
        .map((snap) => User.fromFirestore(snap));
  }*/
}
