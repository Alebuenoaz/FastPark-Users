import 'package:fastpark/usuarios/usuarios.dart';
import 'package:fastpark/blocs/autenticacion.dart';
import 'package:fastpark/design/colores.dart';
import 'package:fastpark/design/textosDes.dart';
import 'package:fastpark/pantallas/loginFP.dart';
import 'package:fastpark/servicios/rutas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'pantallas/home.dart';

final autenticacion = Autenticacion();
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(create: (context) => autenticacion),
      FutureProvider(
        create: (context) => autenticacion.isLoggedIn(),
      ),
      StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged)
    ], child: Plataformas());
  }

  @override
  void dispose() {
    autenticacion.dispose();
    super.dispose();
  }
}

//Para que parezca nativo en iOS y Android

class Plataformas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        theme: CupertinoThemeData(
            //brightness: Brightness.dark,
            primaryColor: ColoresApp.naranja,
            textTheme: CupertinoTextThemeData(
                tabLabelTextStyle: TextosDes.suggestion)),
        home: (isLoggedIn == null)
            ? cargando(false)
            : (isLoggedIn == true)
                ? Home()
                : Login(),
        onGenerateRoute: Rutas.cupertinoRoutes,
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          //brightness: Brightness.dark,
          primarySwatch: ColoresApp.naranjaMaterial,
        ),
        home: (isLoggedIn == null)
            ? cargando(false)
            : (isLoggedIn == true)
                ? Home()
                : Login(),
        onGenerateRoute: Rutas.materialRoutes,
      );
    }
  }

  Widget cargando(bool isIOS) {
    return (isIOS)
        ? CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ));
  }
}
