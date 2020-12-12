import 'package:fastPark_Users/screens/parkingView.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'myHomePage.dart';
import 'register.dart';
import 'parkingView.dart';

class Home extends StatelessWidget {
  static const String id = "HOME";

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
          RaisedButton(
            child: Text('Log In'),
            onPressed: () {
              Navigator.of(context).pushNamed(Login.id);
            },
          ),
          RaisedButton(
            child: Text('Register'),
            onPressed: () {
              Navigator.of(context).pushNamed(Register.id);
            },
          ),
          RaisedButton(
            child: Text('Nobo'),
            onPressed: () {
              Navigator.of(context).pushNamed(MyHomePage.id);
            },
          ),
          RaisedButton(
            child: Text('Vista Parqueo'),
            onPressed: () {
              //Navigator.of(context).pushNamed(ParkingView.id);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ParkingView()));
            },
          ),
        ],
      ),
    );
  }
}
