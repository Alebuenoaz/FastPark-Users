import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reserve extends StatefulWidget {
  static const String id = "RESERVE";

  @override
  _ReserveState createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {
  Firestore firestore = Firestore.instance;
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay startTimePicked;
  TimeOfDay endTimePicked;
  String dropdownValue = 'Mediano';

  Future<Null> _selectStartTime(BuildContext context) async {
    startTimePicked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (startTimePicked != null)
      setState(() {
        startTime = startTimePicked;
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    endTimePicked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (endTimePicked != null)
      setState(() {
        endTime = endTimePicked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Container(
            height: 10.0,
          ),
          Text('Seleccione tiempo de su reserva:'),
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.alarm),
                  iconSize: 50,
                  onPressed: () {
                    _selectStartTime(context);
                  },
                ),
                Text('Desde ${startTime.hour}:${startTime.minute}',
                    style: TextStyle(fontSize: 17)),
                Container(
                  width: 35,
                ),
                IconButton(
                  icon: Icon(Icons.alarm),
                  iconSize: 50,
                  onPressed: () {
                    _selectEndTime(context);
                  },
                ),
                Text('Hasta ${endTime.hour}:${endTime.minute}',
                    style: TextStyle(fontSize: 17)),
              ],
            ),
          ),
          Container(
            height: 10.0,
          ),
          Text('Tamaño de su automovil'),
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Pequeño', 'Mediano', 'Grande']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Container(
            height: 10.0,
          ),
          ButtonTheme(
            minWidth: 380.0,
            height: 50.0,
            child: RaisedButton(
                child: Text('RESERVAR'),
                color: Colors.lightBlue,
                onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
