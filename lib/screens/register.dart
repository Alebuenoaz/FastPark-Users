import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastPark_Users/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'mainPage.dart';

class Register extends StatefulWidget {
  static const String id = "REGISTRATION";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String documentID;
  String name;
  String lastname;
  String ci;
  String email;
  String password;
  String img = '';
  User user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference databaseReference =
      Firestore.instance.collection('users');

  Future<void> registerUser(String newEmail) async {
    print("REGISTRANDO USUARIO");
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: newEmail,
      password: password,
    );

    FirebaseUser firebaseUser = result.user;
    documentID = firebaseUser.uid;
    print("Usuario registrado " + result.user.email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: result,
        ),
      ),
    );
  }

  Future<void> createUser(User newUser) async {
    print("CREANDO USUARIO");
    return await databaseReference.document(documentID).setData({
      'name': name,
      'lastname': lastname,
      'ci': ci,
      'email': email,
      'img': img,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            autocorrect: false,
            obscureText: false,
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              hintText: "Enter Your Name...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: false,
            onChanged: (value) => lastname = value,
            decoration: InputDecoration(
              hintText: "Enter Your Lastname...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: false,
            onChanged: (value) => ci = value,
            decoration: InputDecoration(
              hintText: "Enter Your CI...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Enter Your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter Your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          RaisedButton(
            child: Text('Register'),
            onPressed: () async {
              await registerUser(email);
              await createUser(user);
            },
          ),
        ],
      ),
    );
  }
}
