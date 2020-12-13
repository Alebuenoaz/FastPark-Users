import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastPark_Users/screens/chat.dart';
import 'package:fastPark_Users/screens/reserve.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import '../models/parking.dart';
import 'reserve.dart';

class ParkingView extends StatefulWidget {
  static const String id = "PARKINGVIEW";
  final String idParking;
  final String idUser;

  const ParkingView({Key key, this.idParking, this.idUser}) : super(key: key);

  @override
  _ParkingViewState createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  Firestore firestore = Firestore.instance;
  String idParkingManager;
  String description;
  String direction;
  String days;
  String startTime;
  String endTime;
  String img;
  double pricePerHour;
  int contactNumber;

  Future<Parking> getProductById(String id) async {
    Parking parking = await firestore
        .collection('RegistroParqueos')
        .document(id)
        .get()
        .then((snapshot) {
      try {
        return Parking.fromSnapshot(snapshot);
      } catch (e) {
        print(e);
        return null;
      }
    });

    idParkingManager = parking.idParkingManager;
    description = parking.description;
    direction = parking.direction;
    days = parking.days;
    startTime = parking.startTime;
    endTime = parking.endTime;
    img = parking.img;
    pricePerHour = parking.pricePerHour;
    contactNumber = parking.contactNumber;

    return parking;
  }

  String openDays() {
    String workingDays = "";
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

  Future<void> change(String user1, String user2) async {
    bool crear = true;
    QuerySnapshot variable = await Firestore.instance
        .collection(/*"messages"*/ "chats")
        .getDocuments();
    for (DocumentSnapshot doc in variable.documents) {
      if (doc.data["From"] == user1 && doc.data["To"] == user2) {
        crear = false;
      }
    }
    if (crear) {
      await firestore.collection('chats').add({
        'From': user1,
        'To': user2,
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user1: user1,
          user2: user2,
          current: /*widget.idUser*/ "U1",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future:
          getProductById(widget.idParking), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingFlipping.circle();
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Información del Parqueo"),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: img == null
                                ? AssetImage("assets/loading.png")
                                : NetworkImage(img),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Dirección: \n" + direction),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Descripcion del parqueo: \n" + description),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Precio por hora: \n" +
                          pricePerHour.toString() +
                          " Bs"),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Horario de atención: \n" +
                          startTime +
                          " - " +
                          endTime),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Días disponibles: \n" + openDays()),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Teléfono del parqueo: \n" +
                          contactNumber.toString()),
                      SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      new Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 180.0,
                              height: 50.0,
                              buttonColor: Colors.green,
                              child: RaisedButton(
                                child: Text('Chat'),
                                onPressed: () async {
                                  await change(
                                      /*widget.idUser*/ "U1", idParkingManager);
                                },
                              ),
                            ),
                            Container(
                              width: 25,
                            ),
                            ButtonTheme(
                              minWidth: 180.0,
                              height: 50.0,
                              child: RaisedButton(
                                child: Text('Reservar'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Reserve(
                                        minTime: startTime,
                                        maxTime: endTime,
                                        parkingID: widget.idParking,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
