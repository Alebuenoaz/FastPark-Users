import 'dart:io';
import 'package:fastpark/blocs/autenticacion.dart';
import 'package:fastpark/design/base.dart';
import 'package:fastpark/design/textosDes.dart';
import 'package:fastpark/widget/buttons.dart';
import 'package:fastpark/widget/correoPass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearCuenta extends StatefulWidget {
  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  @override
  void initState() {
    //falso porque solo lo llamamos una vez
    final autenticacion = Provider.of<Autenticacion>(context, listen: false);
    autenticacion.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/homeFP');
    });
    super.initState();
  }

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

  Widget cuerpo(BuildContext context, Autenticacion autenticacion) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('imagenes/logo.png'), fit: BoxFit.fill)),
        ),
        //
        SizedBox(height: 150.0),
        /*
        StreamBuilder<String>(builder: (context, snapshot) {
          // ignore: missing_required_param
          return CorreoPass(
            hintText: 'Nombre',
            isIOS: Platform.isIOS,
            obscureText: false,
            texto: TextInputType.text,
          );
        }),
        //
        SizedBox(height: 10.0),
        //
        StreamBuilder<String>(builder: (context, snapshot) {
          // ignore: missing_required_param
          return CorreoPass(
            hintText: 'Apellido',
            isIOS: Platform.isIOS,
            obscureText: false,
            texto: TextInputType.text,
          );
        }),
        */
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
                onChanged: autenticacion.changeEmail,
              );
            }),
        //
        SizedBox(height: 10.0),
        //
        StreamBuilder<String>(
            stream: autenticacion.password,
            builder: (context, snapshot) {
              // ignore: missing_required_param
              return CorreoPass(
                hintText: 'Contraseña',
                isIOS: Platform.isIOS,
                obscureText: true,
                texto: TextInputType.text,
                errorText: snapshot.error,
                onChanged: autenticacion.changePassword,
              );
            }),
        SizedBox(height: 50.0),
        StreamBuilder<bool>(
            stream: autenticacion.isValid,
            builder: (context, snapshot) {
              return Botones(
                textoBoton: 'Registrar',
                tipoBoton: (snapshot.data == true)
                    ? TipoBoton.BotonLogin
                    : TipoBoton.Deshabilitado,
                onPressed: autenticacion.signupEmail,
              );
            }),
        SizedBox(height: 20.0),
        Padding(
          padding: EstilosBase.listPadding,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: '¿Ya estás registrado? ',
                style: TextosDes.cuerpo,
                children: [
                  TextSpan(
                      text: 'Inicia sesión ahora!',
                      style: TextosDes.link,
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, '/loginFP'))
                ]),
          ),
        )
      ],
    );
  }
}
