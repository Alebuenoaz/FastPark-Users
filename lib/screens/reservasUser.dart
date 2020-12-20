import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/reserva.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../widget/buttons.dart';

class ReservasUser extends StatefulWidget {
  Firestore _fireStore = Firestore.instance;
  @override
  _ReservasUserState createState() => _ReservasUserState();
}

class _ReservasUserState extends State<ReservasUser> {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('FastPark!'),
      ),
      body: StreamProvider<List<Reserva>>.value(
        value: db.streamReservasUser(user),
        child: (user != null)
            ? ReservasList()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ReservasList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var reservas = Provider.of<List<Reserva>>(context);

    return Container(
        height: MediaQuery.of(context).size.height,
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
                          "ID Parqueo: " + widget.idParqueo,
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
                  ],
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
