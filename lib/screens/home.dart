import 'package:fastPark_Users/screens/parkingView.dart';
import 'package:flutter/material.dart';
import 'package:fastPark_Users/screens/searchMap.dart';
import 'package:fastPark_Users/models/location.dart';
import 'package:fastPark_Users/screens/location.dart';

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
            child: Text('Mapas de Parqueos'),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchMap.id);
            },
          ),
          RaisedButton(
            child: Text('Own Location'),
            onPressed: () {
              Navigator.of(context).pushNamed(LocationMap.id);
            },
          ),
        ],
      ),
    );
  }
}
