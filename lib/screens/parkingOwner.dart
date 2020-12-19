import 'dart:io';

import 'package:fast_park/design/colores.dart';
import 'package:fast_park/models/review.dart';
import 'package:fast_park/models/parking.dart';
import 'package:fast_park/screens/parkingRegister.dart';
import 'package:fast_park/screens/parkingView.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:fast_park/widget/reviewWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ParkingOwner extends StatefulWidget {
  @override
  _ParkingOwnerState createState() => _ParkingOwnerState();
}

class _ParkingOwnerState extends State<ParkingOwner> {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Parking>>.value(
        value: db.streamParking(user),
        child: (user != null)
            ? BodyParking()
            : Center(child: CircularProgressIndicator()));
  }
}

class BodyParking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parkings = Provider.of<List<Parking>>(context);
    return (parkings != null)
        ? Scaffold(
            body: (parkings.length > 0)
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ParkingSlot(),
                      ],
                    ),
                  )
                : Center(
                    child: Text('Usted no tiene asignado nigun Parqueo'),
                  ),
            floatingActionButton: (parkings.length == 0)
                ? FloatingActionButton(
                    backgroundColor: ColoresApp.rojo,
                    shape: StadiumBorder(),
                    child: Icon(Icons.add),
                    /*Text(
            'Añadir',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            )/
          ),*/
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ParkingRegister(
                              Parking(
                                documentID: '',
                                idParkingManager: '',
                                description: '',
                                direction: '',
                                days: '',
                                startTime: '',
                                endTime: '',
                                img: '',
                                pricePerHour: 0,
                                contactNumber: 0,
                                userID: 0,
                                ownerID: 0,
                                name: '',
                                lat: '',
                                lng: '',
                              ),
                              true)));
                    },
                  )
                : FloatingActionButton(
                    backgroundColor: ColoresApp.azulclaro,
                    shape: StadiumBorder(),
                    child: Icon(Icons.edit),
                    /*Text(
            'Añadir',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            )/
          ),*/
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ParkingRegister(parkings[0], false)));
                    },
                  ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

/*  Widget cuerpo(context, Autenticacion autenticacion) {
    var user = Provider.of<FirebaseUser>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StreamProvider<List<Parking>>.value(
              value: db.streamParking(user), child: ParkingSlot()),
          //ParkingList(),
          /*StreamProvider<List<Parking>>.value(
          value: db.streamParking(),
          child: ParkingList(),
        ),*/
        ],
      ),
    );
  }
}*/

class ParkingSlot extends StatelessWidget {
  final db = FirestoreServ();
  @override
  Widget build(BuildContext context) {
    //final parkings = Provider.of<List<Parking>>(context);
    var parking = Provider.of<List<Parking>>(context)[0];

    return (parking != null)
        ? Container(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context)
                          .size
                          .width, // container width depending on user device screen width
                      height: 260.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(parking.img),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      StreamProvider<List<Review>>.value(
                          value: db.streamReview(parking.documentID),
                          child: ReviewStar()),
                      /*IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: 32,
                        ),
                        child: StarDisplay(value: 3),
                      ),*/
                      Text(parking.name),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      //height: 260.0,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          Text("Dirección: \n" + parking.direction),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Descripcion del parqueo: \n" +
                              parking.description),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Precio por hora: \n" +
                              parking.pricePerHour.toString() +
                              " Bs"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Horario de atención: \n" +
                              parking.startTime +
                              " - " +
                              parking.endTime),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Días disponibles: \n" + openDays(parking.days)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Teléfono del parqueo: \n" +
                              parking.contactNumber.toString()),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text("Puntuaciones"),
                    children: <Widget>[
                      ReviewWidget(),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class ReviewStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var reviews = Provider.of<List<Review>>(context);
    return (reviews != null)
        ? Container(
            child: IconTheme(
              data: IconThemeData(
                color: Colors.amber,
                size: 32,
              ),
              child: RatingBarIndicator(
                rating: averageStar(reviews),
                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 30.0,
                direction: Axis.horizontal,
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

String openDays(String parkingDays) {
  String workingDays = "";
  String days = parkingDays;
  for (int i = 0; i < days.length; i++) {
    if (days[i] == "1") workingDays += "Lunes - ";
    if (days[i] == "2") workingDays += "Martes - ";
    if (days[i] == "3") workingDays += "Miercoles - ";
    if (days[i] == "4") workingDays += "Jueves - ";
    if (days[i] == "5") workingDays += "Viernes - ";
    if (days[i] == "6") workingDays += "Sabado - ";
    if (days[i] == "7") workingDays += "Domingo - ";
  }
  workingDays = workingDays.substring(0, workingDays.length - 3);
  return workingDays;
}

double averageStar(List<Review> reviews) {
  return reviews.length > 0
      ? (reviews
              .map((review) => double.parse(review.value))
              .reduce((a, b) => a + b) /
          reviews.length)
      : 0;
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
                                ? CircularProgressIndicator()
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
                              builder: (context) =>
                                  ParkingRegister(parking, false)));
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
