import 'package:fast_park/services/firestore.dart';
import 'package:fast_park/services/places_service.dart';
import 'package:fast_park/services/geolocator_service.dart';
import 'package:fast_park/providers/autenticacion.dart';
import 'package:fast_park/design/colores.dart';
import 'package:fast_park/design/textosDes.dart';
import 'package:fast_park/screens/homeFP.dart';
import 'package:fast_park/screens/loginFP.dart';
import 'package:fast_park/services/rutas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/parking.dart';
import 'models/place.dart';
import 'models/usuarios.dart';

final autenticacion = Autenticacion();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreServ();
    return MultiProvider(providers: [
      Provider(create: (context) => autenticacion),
      FutureProvider(
        create: (context) => autenticacion.isLoggedIn(),
      ),
      StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged),
      StreamProvider<User>(create: (context) => autenticacion.user),
      //StreamProvider(create: (context) => firestoreService.streamParking()),
      FutureProvider(create: (context) => locatorService.getLocation()),
      FutureProvider(create: (context) {
        ImageConfiguration configuration =
            createLocalImageConfiguration(context);
        return BitmapDescriptor.fromAssetImage(
            configuration, 'assets/images/parking-icon.png');
      }),
      ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
        update: (context, position, icon, places) {
          return (position != null)
              ? placesService.getPlaces(
                  position.latitude, position.longitude, icon)
              : null;
        },
      )
    ], child: Plataformas());
  }

  @override
  void dispose() {
    autenticacion.dispose();
    super.dispose();
  }
}

class Plataformas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'FastPark!',
        home: (isLoggedIn == null)
            ? cargando(false)
            : (isLoggedIn == true)
                ? HomeFP()
                : Login(),
        onGenerateRoute: Rutas.materialRoutes,
        theme: CupertinoThemeData(
          primaryColor: ColoresApp.naranja,
          scaffoldBackgroundColor: Colors.white,
          textTheme: CupertinoTextThemeData(
            tabLabelTextStyle: TextosDes.suggestion,
          ),
          //brightness: Brightness.dark
        ),
      );
    } else {
      return MaterialApp(
          title: 'FastPark!',
          home: (isLoggedIn == null)
              ? cargando(false)
              : (isLoggedIn == true)
                  ? HomeFP()
                  : Login(),
          onGenerateRoute: Rutas.materialRoutes,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.orange));
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
            ),
          );
  }
}
