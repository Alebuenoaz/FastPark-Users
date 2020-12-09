import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationMap extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<LocationMap> {
  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {

    final currentPosition = Provider.of<Position>(context);

    // double screenWidth = MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio;
    // double screenHeight = MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio;

    // double middleX = screenWidth / 2;
    // double middleY = screenHeight / 2;

    // ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());

    // LatLng middlePoint = await googleMapController.getLatLng(screenCoordinate);
    
    return Scaffold(
      appBar: AppBar(
            title: Center(child: Text('FastPark!')),
          ),
        body: (currentPosition != null) ? 
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
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
              ),
            )
            : Center(
            child: CircularProgressIndicator(),
            ),
    );
  }
}