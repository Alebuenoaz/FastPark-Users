import 'dart:async';
import 'package:fast_park/services/firestore.dart';
import 'package:fast_park/models/usuarios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class Autenticacion {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServ _firestoreServ = FirestoreServ();
  final _user = BehaviorSubject<User>();
  final _error = BehaviorSubject<String>();
  final facebook = FacebookLogin();
  final google = GoogleSignIn(scopes: ['email']);

  final _nombre = BehaviorSubject<String>();
  final _apellido = BehaviorSubject<String>();
  final _ci = BehaviorSubject<String>();
  final _img = BehaviorSubject<String>();

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
  Stream<String> get errorMessage => _error.stream;

  //Transformer

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

      var users = User(
          userId: authResult.user.uid,
          nombre: _nombre.value.trim(),
          apellido: _apellido.value.trim(),
          ci: _ci.value.trim(),
          email: _email.value.trim(),
          img: '' //_img.value.trim(),
          );
      await _firestoreServ.addUser(users);
      _user.sink.add(users);
    } on PlatformException catch (error) {
      print(error);
      _error.sink.add(error.message);
    }
  }

  loginEmail() async {
    print('Registrando usuario');
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var users = await _firestoreServ.usuarioCreado(authResult.user.uid);
      _user.sink.add(users);
    } on PlatformException catch (error) {
      print(error);
      _error.sink.add(error.message);
    }
  }

  signinFacebook() async {
    final res = await facebook.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        final FacebookAccessToken facebookToken = res.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookToken.token);

        final resultado = await _auth.signInWithCredential(credential);

        var existeUsuario =
            await _firestoreServ.usuarioCreado(resultado.user.uid);
        var users =
            User(email: resultado.user.email, userId: resultado.user.uid);
        if (existeUsuario == null) {
          await _firestoreServ.addUser(users);
          _user.sink.add(users);
        } else {
          _user.sink.add(users);
        }

        break;
      case FacebookLoginStatus.Cancel:
        _error.sink.add('Inicio de sesión cancelada');
        break;
      case FacebookLoginStatus.Error:
        _error.sink.add('Inicio de sesión no fue exitoso, intenta nuevamente');
        print(res.error.toString());
        break;
    }
  }

  signinGoogle() async {
    try {
      final GoogleSignInAccount usuarioGoogle = await google.signIn();
      final GoogleSignInAuthentication googleAuth =
          await usuarioGoogle.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final resultado = await _auth.signInWithCredential(credential);

      var existeUsuario =
          await _firestoreServ.usuarioCreado(resultado.user.uid);
      var users = User(email: resultado.user.email, userId: resultado.user.uid);
      if (existeUsuario == null) {
        await _firestoreServ.addUser(users);
        _user.sink.add(users);
      } else {
        _user.sink.add(users);
      }
    } catch (error) {
      _error.sink.add('Inicio de sesión no fue exitoso, intenta nuevamente');
      print(error.toString());
    }
  }

  Future<bool> isLoggedIn() async {
    var usuarioFirebase = await _auth.currentUser();
    if (usuarioFirebase == null) return false;

    var users = await _firestoreServ.usuarioCreado(usuarioFirebase.uid);
    if (users == null) return false;

    _user.sink.add(users);
    return true;
  }

  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  limpiarError() {
    _error.sink.add('');
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
