import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Reserve extends StatefulWidget {
  static const String id = "RESERVE";
  final String minTime;
  final String maxTime;
  final String parkingID;

  const Reserve({Key key, this.minTime, this.maxTime, this.parkingID})
      : super(key: key);

  @override
  _ReserveState createState() => _ReserveState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _ReserveState extends State<Reserve> {
  Firestore firestore = Firestore.instance;
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay startTimePicked;
  TimeOfDay endTimePicked;
  String dropdownValue = 'Mediano';
  TextEditingController carPlateController = new TextEditingController();

  void makeReserve(BuildContext context, String userID) async {
    try {
      String localStartTime = getTimeFormat(startTime);
      String localEndTime = getTimeFormat(endTime);
      String minTime = widget.minTime;
      String maxTime = widget.maxTime;
      if (verifyHours(localStartTime, localEndTime, minTime, maxTime) &&
          dropdownValue != "" &&
          carPlateController.text != "") {
        await firestore.collection('Reservas').add({
          'IDParqueo': widget.parkingID,
          'HoraInicio': localStartTime,
          'HoraFinal': localEndTime,
          'TamañoAuto': dropdownValue,
          'IDUsuario': userID,
          'Placa': carPlateController.text,
          'Estado': 'pendiente',
        });
        //Show completed action toast
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Su reserva fue registrada correctamente"),
        ));
        Navigator.of(context).pop();
      } else {
        _showMyDialog(context,
            "Los datos de su reserva son incorrectos o estan incompletos");
      }
    } catch (e) {
      print(e);
    }
  }

  bool verifyHours(String startTimeString, String endTimeString,
      String minTimeString, String maxTimeString) {
    int initialHour = int.parse(
        startTimeString.split(":")[0] + startTimeString.split(":")[1]);
    int finalHour =
        int.parse(endTimeString.split(":")[0] + endTimeString.split(":")[1]);
    int minHour =
        int.parse(minTimeString.split(":")[0] + minTimeString.split(":")[1]);
    int maxHour =
        int.parse(maxTimeString.split(":")[0] + maxTimeString.split(":")[1]);
    if (initialHour < finalHour &&
        meetTimeBoundries(initialHour, minHour, maxHour) &&
        meetTimeBoundries(finalHour, minHour, maxHour)) {
      return true;
    } else {
      return false;
    }
  }

  bool meetTimeBoundries(int selectedHour, int minHour, int maxHour) {
    if (selectedHour >= minHour && selectedHour <= maxHour)
      return true;
    else
      return false;
  }

  String getTimeFormat(TimeOfDay time) {
    String timeHourString = (time.hour).toString();
    String timeMinuteString = (time.minute).toString();

    if (timeMinuteString.length == 1) {
      if (timeMinuteString == '0')
        timeMinuteString += '0';
      else {
        timeMinuteString = '0' + timeMinuteString;
      }
    }
    return "$timeHourString:$timeMinuteString";
  }

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

  Future _showMyDialog(BuildContext context, String warning) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialog(context, warning),
    );
  }

  Widget _buildAlertDialog(BuildContext context, String warning) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(warning),
      actions: [
        FlatButton(
            child: Text("Aceptar"),
            textColor: Colors.blue,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
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
          Text('Seleccione el tiempo que durará su reserva:'),
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
                  width: 25,
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
            style: TextStyle(color: Colors.blueAccent),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
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
          TextField(
            controller: carPlateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Placa del Automóvil',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(9),
              UpperCaseTextFormatter()
            ],
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
                onPressed: () async {
                  makeReserve(context, user.uid);
                }),
          ),
        ],
      ),
    );
  }
}
