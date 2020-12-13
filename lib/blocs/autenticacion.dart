import 'dart:async';
import 'package:fastpark/servicios/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import '../usuarios/usuarios.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class Autenticacion {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<User>();
  final _nombre = BehaviorSubject<String>();
  final _apellido = BehaviorSubject<String>();
  final _ci = BehaviorSubject<String>();
  final _img = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServ _firestoreServ = FirestoreServ();

//Recibir Datos
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get nombre => _nombre.stream.transform(validateNombre);
  Stream<String> get apellido => _apellido.stream.transform(validateApellido);
  Stream<String> get ci => _ci.stream.transform(validateCi);
  Stream<String> get img => _img.stream.transform(validateImg);

  Stream<bool> get isValid => CombineLatestStream.combine2(
      email,
      password,
      /*nombre, apellido,*/ (
        email,
        password,
        /*nombre, apellido*/
      ) =>
          true);
  Stream<User> get user => _user.stream;

//Set
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeNombre => _nombre.sink.add;
  Function(String) get changeApellido => _apellido.sink.add;
  Function(String) get changeCi => _ci.sink.add;
  Function(String) get changeImg => _img.sink.add;

//Cerrar
  dispose() {
    _email.close();
    _password.close();
    _nombre.close();
    _apellido.close();
    _ci.close();
    _img.close();
    _user.close();
  }

//Transformar
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('Ingrese un correo valido');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password.trim());
    } else {
      sink.addError('Su contraseña debe tener como minimo 8 caracteres');
    }
  });

  final validateNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.length >= 1) {
      sink.add(nombre.trim());
    } else {
      sink.addError('Introduzca su nombre');
    }
  });

  final validateApellido = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.length >= 1) {
      sink.add(nombre.trim());
    } else {
      sink.addError('Introduzca su apellido');
    }
  });

  final validateCi =
      StreamTransformer<String, String>.fromHandlers(handleData: (ci, sink) {
    if (double.tryParse(ci) != null) {
      sink.add(ci.trim());
    } else {
      sink.addError('Introduzca un CI válido');
    }
  });

  final validateImg =
      StreamTransformer<String, String>.fromHandlers(handleData: (img, sink) {
    if (img.length >= 1) {
      sink.add(img.trim());
    } else {
      sink.addError('Introduzca una imagen válida');
    }
  });

  //Funciones crear cuenta

  signupEmail() async {
    print('Registrando usuario');
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      //var users = User(userId: authResult.user.uid, email: _email.value.trim());
      var users = User(
          userId: authResult.user.uid,
          nombre: _nombre.value.trim(),
          apellido: _apellido.value.trim(),
          ci: _ci.value.trim(),
          email: _email.value.trim(),
          img: '' //_img.value.trim(),
          );

      await _firestoreServ.addUser(users);
    } catch (error) {
      print(error);
    }
  }

  loginEmail() async {
    print('Iniciando sesion');
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreServ.usuarioCreado(authResult.user.uid);
      _user.sink.add(user);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> isLoggedIn() async {
    var firebaseUser = await _auth.currentUser();
    if (firebaseUser == null) return false;

    var user = await _firestoreServ.usuarioCreado(firebaseUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  updateUser() async {
    print('Actualizando usuario');
    print(nombre.last);
    try {
      //AuthResult authResult = await _auth.createUserWithEmailAndPassword(
      //    email: _email.value.trim(), password: _password.value.trim());
      //var users = User(userId: authResult.user.uid, email: _email.value.trim());
      var users = User(
          userId: _user.value.userId,
          nombre: _apellido.value.trim(),
          apellido: _apellido.value.trim(),
          ci: _ci.value.trim(),
          email: _email.value.trim(),
          img: '' //_img.value.trim(),
          );
      print("Nombre" + _nombre.value);

      await _firestoreServ.updateUser(users);
    } catch (error) {
      print(error);
    }
  }

  printData() async {
    print('Nombre usuario');
    print(_nombre.value);
  }
}
