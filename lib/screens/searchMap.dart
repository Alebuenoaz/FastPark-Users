import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class SearchMap extends StatefulWidget {
  static const String id = "SEARCH_MAP";
  
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<SearchMap> {
  GoogleMapController controller;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  void initMarker(specify, specifyId) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/parking-icon.png', 80);
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      onTap: (){
        print(markerIdVal);
      },
      position:
          LatLng(double.parse(specify['lat']), double.parse(specify['lng'])),
      infoWindow: InfoWindow(title: specify['name'], snippet: specify['direction']),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

   
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  getMarkerData() async {
    Firestore.instance.collection('parqueos').getDocuments().then((myMockDoc) {
      if (myMockDoc.documents.isNotEmpty) {
        for (int i = 0; i < myMockDoc.documents.length; i++) {
          initMarker(myMockDoc.documents[i].data, myMockDoc.documents[i].documentID);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final currentPosition = Provider.of<Position>(context);
    
    return Scaffold(
      appBar: AppBar(
            title: Text('FastPark!'),
          ),
        body: (currentPosition != null) ? 
            GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude),zoom: 18.0),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            },
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            )
            : Center(
            child: CircularProgressIndicator(),
            ),
    );
  }
}