import 'dart:async';
import 'dart:io';
import 'package:fastpark/blocs/autenticacion.dart';
import 'package:fastpark/design/base.dart';
import 'package:fastpark/design/textosDes.dart';
import 'package:fastpark/widget/botonesredes.dart';
import 'package:fastpark/widget/buttons.dart';
import 'package:fastpark/widget/correoPass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  StreamSubscription _usuarioSubs;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    //falso porque solo lo llamamos una vez
    final autenticacion = Provider.of<Autenticacion>(context, listen: false);
    widget._usuarioSubs = autenticacion.user.listen((user) {
      if (user != null) Navigator.pushReplacementNamed(context, '/homeFP');
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._usuarioSubs.cancel();
    super.dispose();
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
        //
        StreamBuilder<String>(
            stream: autenticacion.email,
            builder: (context, snapshot) {
              return CorreoPass(
                iOSIcons: CupertinoIcons.mail_solid,
                hintText: 'Correo',
                isIOS: Platform.isIOS,
                androidIcons: Icons.email,
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
              return CorreoPass(
                iOSIcons: CupertinoIcons.lock,
                hintText: 'Contraseña',
                isIOS: Platform.isIOS,
                androidIcons: Icons.lock,
                obscureText: true,
                texto: TextInputType.text,
                errorText: snapshot.error,
                onChanged: autenticacion.changePassword,
              );
            }),
        SizedBox(height: 100.0),
        StreamBuilder<bool>(
            stream: autenticacion.isValid,
            builder: (context, snapshot) {
              return Botones(
                textoBoton: 'Iniciar Sesión',
                tipoBoton: (snapshot.data == true)
                    ? TipoBoton.BotonLogin
                    : TipoBoton.Deshabilitado,
                onPressed: autenticacion.loginEmail,
              );
            }),
        SizedBox(height: 5.0),
        Center(
          child: Text('Inicia sesión con Facebook o Google',
              style: TextosDes.suggestion),
        ),
        Padding(
          padding: EstilosBase.listPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: missing_required_param
              BotonesRedes(
                tipoRedes: TipoRedes.Facebook,
              ),
              // ignore: missing_required_param
              BotonesRedes(
                tipoRedes: TipoRedes.Google,
              ),
            ],
          ),
        ),
        Padding(
          padding: EstilosBase.listPadding,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: '¿Nuevo por aquí? ',
                style: TextosDes.cuerpo,
                children: [
                  TextSpan(
                      text: '¡Registrate ahora!',
                      style: TextosDes.link,
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, '/crearFP'))
                ]),
          ),
        )
      ],
    );
  }
}
