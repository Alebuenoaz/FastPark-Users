//Esta clase es mas limitada que una clase normal
//pero nos permite llamar a assets directamente
//sin iniciar la clase desde otro widget

import 'package:fast_park/screens/location.dart';
import 'package:fast_park/screens/searchMap.dart';
import 'package:fast_park/screens/homeFP.dart';
import 'package:fast_park/screens/crearFP.dart';
import 'package:fast_park/screens/loginFP.dart';
import 'package:fast_park/screens/owner.dart';
import 'package:fast_park/screens/parqueosOwner.dart';
import 'package:fast_park/screens/usuarioHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Rutas {
  //Rutas para android
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/homeFP":
        return MaterialPageRoute(builder: (context) => HomeFP());

      case "/crearFP":
        return MaterialPageRoute(builder: (context) => CrearCuenta());

      case "/loginFP":
        return MaterialPageRoute(builder: (context) => Login());

      case "/ownerFP":
        return MaterialPageRoute(builder: (context) => Owner());

      case "/parqueosFP":
        return MaterialPageRoute(builder: (context) => ParqueosOwner());

      case "/usuarioHomeFP":
        return MaterialPageRoute(builder: (context) => HomeUsuario());

      case "/searchMap":
        return MaterialPageRoute(builder: (context) => SearchMap());

      case "/ownLocation":
        return MaterialPageRoute(builder: (context) => LocationMap());

      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }

  //Rutas para iOS
  static CupertinoPageRoute cupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/homeFP":
        return CupertinoPageRoute(builder: (context) => HomeFP());

      case "/crearFP":
        return CupertinoPageRoute(builder: (context) => CrearCuenta());

      case "/loginFP":
        return CupertinoPageRoute(builder: (context) => Login());

      case "/ownerFP":
        return CupertinoPageRoute(builder: (context) => Owner());

      case "/parqueosFP":
        return CupertinoPageRoute(builder: (context) => ParqueosOwner());

      case "/usuarioHomeFP":
        return CupertinoPageRoute(builder: (context) => HomeUsuario());

      case "/searchMap":
        return CupertinoPageRoute(builder: (context) => SearchMap());

      case "/ownLocation":
        return CupertinoPageRoute(builder: (context) => LocationMap());

      default:
        return CupertinoPageRoute(builder: (context) => Login());
    }
  }
}
