import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastPark_Users/screens/chat.dart';
import 'package:fastPark_Users/screens/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'mainPage.dart';

class Register extends StatefulWidget {
  static const String id = "REGISTRATION";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;
  String name;
  String uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference databaseReference =
      Firestore.instance.collection('users');

  Future<void> registerUser() async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    FirebaseUser user = result.user;
    uid = user.uid;
    print("Usuario registrado " + result.user.email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: result,
        ),
      ),
    );
  }

  Future<void> createUser(String name, String email, String uid) async {
    return await databaseReference.document(uid).setData({
      'name': name,
      'email': email,
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
          TextField(
            autocorrect: false,
            obscureText: false,
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              hintText: "Enter Your Name...",
              border: const OutlineInputBorder(),
            ),
          ),
          RaisedButton(
            child: Text('Register'),
            onPressed: () async {
              await registerUser();
              await createUser(name, email, uid);
            },
          ),
        ],
      ),
    );
  }
}
