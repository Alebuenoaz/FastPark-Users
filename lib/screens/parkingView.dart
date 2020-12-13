import 'dart:io';

import 'package:fast_park/providers/autenticacion.dart';
import 'package:fast_park/models/parking.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParkingView extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<ParkingView> {
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
    return ListView(
      children: <Widget>[
        StreamProvider<List<Parking>>.value(
          value: db.streamParking(user),
          child: ParkingList(),
        ),
      ],
    );
  }
}

class ParkingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var parkings = Provider.of<List<Parking>>(context);

    return Container(
      height: 300,
      child: ListView(
          /*children: parkings.map((parking) {
          return Card(
            child: ListTile(
              leading:
                  Text(/*parking.img*/ 'Text', style: TextStyle(fontSize: 50)),
              title: Text(/*parking.userID.toString()*/ 'title'),
              subtitle:
                  //Text('Deals ${parking.description} hitpoints of damage'),
                  Text('Subtitle'),
              //onTap: () => ,
            ),
          );
        }).toList(),*/
          ),
    );
  }
}
