import 'dart:io';

import 'package:fast_park/providers/autenticacion.dart';
import 'package:fast_park/models/parking.dart';
import 'package:fast_park/screens/parkingView.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Parkings extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parkings> {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    final autenticacion = Provider.of<Autenticacion>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(context, autenticacion),
      );
    } else {
      return Scaffold(
        body: cuerpo(context, autenticacion),
      );
    }
  }

  Widget cuerpo(context, Autenticacion autenticacion) {
    var user = Provider.of<FirebaseUser>(context);
    return Column(
      children: <Widget>[
        StreamProvider<List<Parking>>.value(
            value: db.streamParking(user), child: ParkingList()),
        //ParkingList(),
        /*StreamProvider<List<Parking>>.value(
          value: db.streamParking(),
          child: ParkingList(),
        ),*/
      ],
    );
  }
}

class ParkingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final parkings = Provider.of<List<Parking>>(context);
    var parkings = Provider.of<List<Parking>>(context);

    return Container(
        height: 300,
        child: (parkings != null)
            ? ListView.builder(
                itemCount: parkings.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(parkings[index].contactNumber.toString()),
                    trailing: Text(parkings[index].description),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ParkingView(parkings[index].documentID)));
                    },
                  );
                })
            : Center(child: CircularProgressIndicator()));
  }
}
