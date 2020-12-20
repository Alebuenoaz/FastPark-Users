import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/reserva.dart';
import 'package:fast_park/models/parking.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../widget/buttons.dart';

class ReservasOwner extends StatefulWidget {
  Firestore _fireStore = Firestore.instance;
  @override
  _ReservasOwnerState createState() => _ReservasOwnerState();
}

class _ReservasOwnerState extends State<ReservasOwner> {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Parking>>.value(
        value: db.streamParking(user),
        child: (user != null)
            ? ParkingProvider()
            : Center(child: CircularProgressIndicator()));
  }
}

class ParkingProvider extends StatelessWidget {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var parkings = Provider.of<List<Parking>>(context);
    return Container(
        //child: SingleChildScrollView(
        child: StreamProvider<List<Reserva>>.value(
      value: db.streamReservasOwner(parkings[0].documentID),
      child: (parkings != null)
          ? ReservasList()
          : Center(
              child: CircularProgressIndicator(),
            ),
    )
        //),
        );
  }
}

class ReservasList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var reservas = Provider.of<List<Reserva>>(context);

    return Container(
        height: 300,
        child: (reservas != null)
            ? (reservas.length > 0)
                ? ListView(
                    children: reservas.map((reserva) {
                    //itemCount: reviews.length,
                    //itemBuilder: (context, index) {
                    return ReservaCard(
                      idUsuario: reserva.idUsuario,
                      idParqueo: reserva.idParqueo,
                      horaInicio: reserva.horaInicio,
                      horaFinal: reserva.horaFinal,
                      tamAuto: reserva.tamAuto,
                    );
                  }).toList())
                : Center(child: Text("No tiene reservas disponibles"))
            : Center(child: CircularProgressIndicator()));

    /*StreamBuilder(
        stream: widget._fireStore.collection('Reservas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("No tiene reservas disponibles");
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                String idParqueo = snapshot.data.documents[index]['IDParqueo'];
                String horaInicio =
                    snapshot.data.documents[index]['HoraInicio'];
                String horaFinal = snapshot.data.documents[index]['HoraFinal'];
                String tamAuto = snapshot.data.documents[index]['TamañoAuto'];
                return ReservaCard(
                  idParqueo: idParqueo,
                  horaInicio: horaInicio,
                  horaFinal: horaFinal,
                  tamAuto: tamAuto,
                );
              },
            );
          }
        });*/
  }
}

class ReservaCard extends StatefulWidget {
  String idParqueo;
  String horaInicio;
  String horaFinal;
  String tamAuto;
  String idUsuario;
  ReservaCard(
      {this.idUsuario,
      this.idParqueo,
      this.horaInicio,
      this.horaFinal,
      this.tamAuto});
  @override
  _ReservaCardState createState() => _ReservaCardState();
}

class _ReservaCardState extends State<ReservaCard> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return (widget.idParqueo != null)
        ? Container(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                      child: ListTile(
                        title: Text(
                          "ID Usuario: " + widget.idUsuario,
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                    ),

                    //Text("Id Reserva: " + reserva.idReserva),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Tamaño auto: " + widget.tamAuto),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Text("Hora final: " + widget.horaInicio),
                          Spacer(),
                          Text("Hora inicio: " + widget.horaFinal),
                        ],
                      ),
                    ),
                    Botones(
                      textoBoton: 'Cancelar reserva',
                      tipoBoton: TipoBoton.BotonLogin,
                      onPressed: () async {
                        //await cancelar(context);
                        //Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
