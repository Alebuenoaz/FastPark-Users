import 'dart:io';

import 'package:fast_park/providers/autenticacion.dart';
import 'package:fast_park/models/parking.dart';
import 'package:fast_park/screens/parkingRegister.dart';
import 'package:fast_park/screens/parkingView.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
            ? ListView(
                children: parkings.map((parking) {
                  //itemCount: parkings.length,
                  //itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: parking.img == null
                                ? AssetImage("assets/loading.png")
                                : NetworkImage(parking.img),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      //Text(parking.img, style: TextStyle(fontSize: 50)),
                      title: Text(parking.direction),
                      subtitle: //Text(parking.description),
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 3.0,
                          ),
                          //(places[index].rating != null)
                          (true)
                              ? Row(
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: 3,
                                      itemBuilder: (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 10.0,
                                      direction: Axis.horizontal,
                                    )
                                  ],
                                )
                              : Row(),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(parking.description),
                        ],
                      ),
                      onTap: () {
                        //},
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ParkingView(parking.documentID)));
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ParkingRegister(parking)));
                        },
                      ),
                    ),
                  );
                  /*return ListTile(
                    title: Text(parkings[index].contactNumber.toString()),
                    trailing: Text(parkings[index].description),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ParkingView(parkings[index].documentID)));
                    },
                    
                  );*/
                }).toList(),
              )
            //})
            : Center(child: CircularProgressIndicator()));
    //);
  }
}
