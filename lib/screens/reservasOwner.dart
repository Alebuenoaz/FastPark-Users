import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ReservasOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: getReservas(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("No tiene reservas");
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildReservaCard(context, snapshot.data.documents[index]));
          }),
    );
  }

  Stream<QuerySnapshot> getReservas(BuildContext context) async* {
    final idParqueo = await Provider.of(context).auth.getCurrentIDPARQUEO();
    yield* Firestore.instance
        .collection('IDParqueo')
        .document(idParqueo)
        .collection('Reservas')
        .snapshots();
  }

  Widget buildReservaCard(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return new Container(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 50.0),
              child: Row(
                children: <Widget>[
                  Text("ID Parqueo: " + documentSnapshot['IDParqueo'],
                      style: new TextStyle(
                        fontSize: 30.0,
                      )),
                ],
              ),
            ),

            //Text("Id Reserva: " + reserva.idReserva),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Text("Tamaño auto: " + documentSnapshot['TamañoAuto']),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Row(
                children: <Widget>[
                  Text("Hora final: " + documentSnapshot['horaFinal']),
                  Spacer(),
                  Text("Hora inicio: " + documentSnapshot['horaInicio)']),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

// class ReservaCard {
//   final String idParqueo;
//   final String horaFinal;
//   final String horaInicio;
//   final String tamAuto;
//   final String idReserva;

//   ReservaCard(this.idParqueo, this.horaFinal, this.horaInicio, this.tamAuto,
//       this.idReserva);
// }
