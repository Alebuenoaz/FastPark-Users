import 'package:fastpark/blocs/autenticacion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
//import 'package:provider/provider.dart';

class Cuenta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(context),
      );
    } else {
      Scaffold(
        body: cuerpo(context),
      );
    }
  }

  Widget cuerpo(context) {
    //var autenticacion = Provider.of<Autenticacion>(context);
    return Center(
      child: Text('Cerrar sesion'),
    );
  }
}
