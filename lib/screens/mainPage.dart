import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class MainPage extends StatefulWidget {
  static const String id = "MAIN";
  final AuthResult user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String name;

  getdata() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.user.user.uid)
        .get();

    name = variable.data['name'];
  }

  final databaseReference = Firestore.instance;
  Future<User> _getUser() async {
    User user = await databaseReference
        .collection("users")
        .document(widget.user.user.uid)
        .get()
        .then((snapshot) {
      try {
        return User.fromFirestore(snapshot);
      } catch (e) {
        print(e);
        return null;
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _getUser(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Espere un momento, cargando ...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.user.user.email),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Nombre de usuario: " + snapshot.data.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Correo : " + snapshot.data.email,
                      border: const OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
