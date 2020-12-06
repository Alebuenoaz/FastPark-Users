import 'package:fastPark_Users/screens/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/mainPage.dart';
import 'screens/myHomePage.dart';
import 'screens/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        //home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: Home.id,
        routes: {
          MyHomePage.id: (context) => MyHomePage(),
          Home.id: (context) => Home(),
          Register.id: (context) => Register(),
          Login.id: (context) => Login(),
          MainPage.id: (context) => MainPage(),
          UserList.id: (context) => UserList(),
        });
  }
}
