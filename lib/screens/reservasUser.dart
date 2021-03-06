import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/parking.dart';
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
                      idReserva: reserva.idReserva,
                      idUsuario: reserva.idUsuario,
                      idParqueo: reserva.idParqueo,
                      horaInicio: reserva.horaInicio,
                      horaFinal: reserva.horaFinal,
                      tamAuto: reserva.tamAuto,
                      placa: reserva.placa,
                      estado: reserva.estado,
                    );
                  }).toList())
                : Center(child: Text("No tiene reservas disponibles"))
            : Center(child: CircularProgressIndicator()));
  }
}

class ReservaCard extends StatefulWidget {
  String idReserva;
  String idParqueo;
  String horaInicio;
  String horaFinal;
  String tamAuto;
  String idUsuario;
  String placa;
  String estado;
  ReservaCard({
    this.idReserva,
    this.idUsuario,
    this.idParqueo,
    this.horaInicio,
    this.horaFinal,
    this.tamAuto,
    this.placa,
    this.estado,
  });
  @override
  _ReservaCardState createState() => _ReservaCardState();
}

class _ReservaCardState extends State<ReservaCard> {
  bool isChecked = false;
  final db = FirestoreServ();
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
                        title: FutureBuilder(
                          future: db.getParking(widget.idParqueo),
                          builder: (BuildContext context,
                              AsyncSnapshot<Parking> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              return Column(
                                children: [
                                  Text(
                                    "Nombre del propietario: ",
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                  Text(
                                    snapshot.data.name,
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                  Text(
                                    'Dirección: ' + snapshot.data.direction,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        /*Text(
                          "ID Parqueo: " + widget.idParqueo,
                          style: TextStyle(fontSize: 30.0),
                        ),*/
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

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Row(
                        children: <Widget>[
                          Center(child: Text("Estado: " + widget.estado)),
                        ],
                      ),
                    ),

                    MaterialButton(
                      splashColor: Theme.of(context).secondaryHeaderColor,
                      color: Theme.of(context).primaryColor,
                      shape: StadiumBorder(),
                      child: Text(
                        'Cancelar Reserva',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await db.updateReserva(Reserva(
                          idReserva: widget.idReserva,
                          idParqueo: widget.idParqueo,
                          idUsuario: widget.idUsuario,
                          horaInicio: widget.horaInicio,
                          horaFinal: widget.horaFinal,
                          tamAuto: widget.tamAuto,
                          placa: widget.placa,
                          estado: 'cancelado',
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
