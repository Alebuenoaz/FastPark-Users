import 'package:fastPark_Users/screens/parkingView.dart';
import 'package:fastPark_Users/screens/reserve.dart';
import 'package:fastPark_Users/screens/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fastPark_Users/models/place.dart';
import 'package:fastPark_Users/screens/location.dart';
import 'package:fastPark_Users/screens/parkingView.dart';
import 'package:fastPark_Users/screens/reserve.dart';
import 'package:fastPark_Users/screens/searchMap.dart';
import 'package:fastPark_Users/screens/userlist.dart';
// import 'package:pruebaflutter/screens/search.dart';
// import 'package:pruebaflutter/screens/searchMap.dart';
import 'package:fastPark_Users/services/geolocator_service.dart';
import 'package:fastPark_Users/services/places_service.dart';
import 'package:fastPark_Users/models/location.dart';

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/mainPage.dart';
import 'screens/myHomePage.dart';
import 'screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration = createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(configuration, 'assets/images/parking-icon.png');
        }),
        ProxyProvider2<Position, BitmapDescriptor,Future<List<Place>>>(
          update: (context,position,icon,places) {
            return (position != null) ? placesService.getPlaces(position.latitude,position.longitude, icon) : null;
          },
        )
      ],
    child: MaterialApp(
        title: 'FastPark!',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home: Home(),
        routes: {
          MyHomePage.id: (context) => MyHomePage(),
          Home.id: (context) => Home(),
          Register.id: (context) => Register(),
          Login.id: (context) => Login(),
          MainPage.id: (context) => MainPage(),
          UserList.id: (context) => UserList(),
          ParkingView.id: (context) => ParkingView(),
          Reserve.id: (context) => Reserve(),
          SearchMap.id: (context) => SearchMap(),
          LocationMap.id: (context) => LocationMap(),
        }
      ),
    );
  }
}
