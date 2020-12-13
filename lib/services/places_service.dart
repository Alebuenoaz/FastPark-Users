// import 'dart:js_util';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fast_park/models/place.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyCjtPuIu2tCRbMVk9FRgMgRhjTIyoy2-yM';
  // final databaseReference = Firestore.instance;

  Future<List<Place>> getPlaces(
      double lat, double lng, BitmapDescriptor icon) async {
    // var response = await http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key');
    // var json = convert.jsonDecode(response.body);
    var json = {
      "results": [
        {
          "geometry": {
            "location": {"lat": -17.362672, "lng": -66.147716}
          },
          "name": "Parqueo Prueba",
          "rating": 4,
          "user_ratings_total": 10,
          "vicinity": "Cafetales #1378, Amapolas"
        },
        {
          "geometry": {
            "location": {"lat": -17.362488, "lng": -66.148913}
          },
          "name": "Parqueo Prueba 2",
          "rating": 1,
          "user_ratings_total": 10,
          "vicinity": "Cafetales #1478, Amapolas"
        }
      ]
    };
    var jsonResults = json['results'];
    // var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place, icon)).toList();
  }

  // void _getData() {
  // databaseReference
  //     .collection("parqueos")
  //     .getDocuments()
  //     .then((QuerySnapshot snapshot) {
  //   snapshot.documents.forEach((f) => print('${f.data}}'));
  //   });
  // }
}
