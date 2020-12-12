//Esta clase es mas limitada que una clase normal
//pero nos permite llamar a assets directamente
//sin iniciar la clase desde otro widget

import 'package:fastpark/pantallas/home.dart';
import 'package:fastpark/pantallas/crearFP.dart';
import 'package:fastpark/pantallas/loginFP.dart';
import 'package:fastpark/pantallas/owner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Rutas {
  //Rutas para android
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/homeFP":
        return MaterialPageRoute(builder: (context) => Home());

      case "/crearFP":
        return MaterialPageRoute(builder: (context) => CrearCuenta());

      case "/loginFP":
        return MaterialPageRoute(builder: (context) => Login());

      case "/ownerFP":
        return MaterialPageRoute(builder: (context) => Owner());

      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }

  //Rutas para iOS
  static CupertinoPageRoute cupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/homeFP":
        return CupertinoPageRoute(builder: (context) => Home());

      case "/crearFP":
        return CupertinoPageRoute(builder: (context) => CrearCuenta());

      case "/loginFP":
        return CupertinoPageRoute(builder: (context) => Login());

      case "/ownerFP":
        return CupertinoPageRoute(builder: (context) => Owner());

      default:
        return CupertinoPageRoute(builder: (context) => Login());
    }
  }
}
