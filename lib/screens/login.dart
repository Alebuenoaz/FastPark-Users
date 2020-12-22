import 'package:fast_park/screens/userlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const String id = "LOGIN";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    AuthResult user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("Usuario " + user.user.email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserList(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Ingrese su correo ...",
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
              hintText: "Ingrese su contraseña ...",
              border: const OutlineInputBorder(),
            ),
          ),
          RaisedButton(
            child: Text('Log In'),
            onPressed: () async {
              await loginUser();
            },
          ),
        ],
      ),
    );
  }
}
