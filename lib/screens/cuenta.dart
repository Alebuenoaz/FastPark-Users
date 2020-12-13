import 'package:fast_park/models/usuarios.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:fast_park/widget/correoPass.dart';
import 'package:fast_park/widget/buttons.dart';
import 'package:fast_park/blocs/autenticacion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class Cuenta extends StatefulWidget {
  @override
  _CuentaState createState() => _CuentaState();
}

class _CuentaState extends State<Cuenta> {
  final db = FirestoreServ();
  String nombre;
  String apellido;
  String ci;
  String correo;

  @override
  Widget build(BuildContext context) {
    final autenticacion = Provider.of<Autenticacion>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(context, autenticacion),
      );
    } else {
      return Scaffold(
        body: cuerpo(context, autenticacion),
      );
    }
  }

  Widget cuerpo(context, Autenticacion autenticacion) {
    //var isLoggedIn = Provider.of<bool>(context);
    var user = Provider.of<FirebaseUser>(context);
    bool loaded = user != null;
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        if (loaded) ...[
          SizedBox(height: 100.0),
          StreamBuilder<String>(
              stream: autenticacion.nombre,
              builder: (context, snapshot) {
                // ignore: missing_required_param
                return CorreoPass(
                  hintText: 'Nombre',
                  isIOS: Platform.isIOS,
                  obscureText: false,
                  texto: TextInputType.text,
                  errorText: snapshot.error,
                  onChanged: (text) {
                    autenticacion.changeNombre;
                    nombre = text;
                  },
                  //print(text);
                  value: user.uid ?? '',
                );
              }),
          SizedBox(height: 10.0),
          StreamBuilder<String>(
              stream: autenticacion.apellido,
              builder: (context, snapshot) {
                // ignore: missing_required_param
                return CorreoPass(
                  hintText: 'Apellido',
                  isIOS: Platform.isIOS,
                  obscureText: false,
                  texto: TextInputType.text,
                  errorText: snapshot.error,
                  onChanged: (text) {
                    autenticacion.changeApellido;
                    apellido = text;
                  },
                  value: snapshot.data ?? '',
                );
              }),
          SizedBox(height: 10.0),
          StreamBuilder<String>(
              stream: autenticacion.ci,
              builder: (context, snapshot) {
                // ignore: missing_required_param
                return CorreoPass(
                  hintText: 'CI',
                  isIOS: Platform.isIOS,
                  obscureText: false,
                  texto: TextInputType.number,
                  errorText: snapshot.error,
                  onChanged: (text) {
                    autenticacion.changeCi;
                    ci = text;
                  },
                  value: snapshot.data ?? '',
                );
              }),
          SizedBox(height: 10.0),
          //
          StreamBuilder<String>(
              stream: autenticacion.email,
              builder: (context, snapshot) {
                // ignore: missing_required_param
                return CorreoPass(
                  hintText: 'Correo',
                  isIOS: Platform.isIOS,
                  texto: TextInputType.emailAddress,
                  obscureText: false,
                  errorText: snapshot.error,
                  onChanged: (text) {
                    autenticacion.changeEmail;
                    correo = text;
                  },
                  value: user.email ?? '',
                );
              }),
        ],
        SizedBox(height: 50.0),
        StreamBuilder<User>(
            stream: autenticacion.user,
            builder: (context, snapshot) {
              return Botones(
                textoBoton: 'Actualizar',
                tipoBoton: TipoBoton.BotonLogin,
                onPressed: () => {
                  db.updateUser(User(
                    userId: user.uid,
                    nombre: nombre,
                    apellido: apellido,
                    ci: ci,
                    email: correo,
                    img: '',
                  )),
                  autenticacion.printData()
                },
              );
            }),
        SizedBox(height: 50.0),
        Botones(
          textoBoton: 'Cerrar Sesion',
          tipoBoton: TipoBoton.BotonLogin,
          onPressed: () => autenticacion.logout(),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
