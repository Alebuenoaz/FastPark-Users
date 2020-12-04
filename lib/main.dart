import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pruebaflutter/models/place.dart';
import 'package:pruebaflutter/screens/search.dart';
import 'package:pruebaflutter/services/geolocator_service.dart';
import 'package:pruebaflutter/services/places_service.dart';

void main() {
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
        home: Search(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  int _counter = 0;

  void _createRecord() async {
    _counter++;
    await databaseReference.collection("parqueos")
      .document("1")
      .setData({
        'title': 'Chupate esa Drope',
        'description': 'Parece que funciona Firebase'
      });

    DocumentReference ref = await databaseReference.collection("parqueos")
      .add({
        'title': 'parqueo'+ _counter.toString(),
        'description': 'Descripcion del parqueo nro '+ _counter.toString()
      });
    print(ref.documentID);
  }

  void _getData() {
  databaseReference
      .collection("parqueos")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void _updateData() {
    try {
      databaseReference
        .collection('parqueos')
        .document('1')
        .updateData({'description': 'Seguila chupando Drope'});
    } catch (e) {
      print(e.toString());
    }
  }

  void _deleteData() {
    try {
      databaseReference
        .collection('parqueos')
        .document('1')
        .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: _createRecord,
          ),
          RaisedButton(
            child: Text('Read'),
            onPressed: _getData,
          ),
          RaisedButton(
            child: Text('Update'),
            onPressed: _updateData,
          ),
          RaisedButton(
            child: Text('Delete'),
            onPressed: _deleteData,
          ),
        ],
      )), //center
    );
  }
}
