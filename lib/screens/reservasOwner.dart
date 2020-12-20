import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../widget/buttons.dart';

class ReservasOwner extends StatefulWidget {
  Firestore _fireStore = Firestore.instance;
  @override
  _ReservasOwnerState createState() => _ReservasOwnerState();
}

class _ReservasOwnerState extends State<ReservasOwner> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        });
  }
}

class ReservaCard extends StatefulWidget {
  String idParqueo;
  String horaInicio;
  String horaFinal;
  String tamAuto;
  ReservaCard({this.idParqueo, this.horaInicio, this.horaFinal, this.tamAuto});
  @override
  _ReservaCardState createState() => _ReservaCardState();
}

class _ReservaCardState extends State<ReservaCard> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
