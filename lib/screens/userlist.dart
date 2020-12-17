import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/usuarios.dart';

//needed for client: change(), harcoded buttons
//needed for owner: getall(), all inside expanded() in _UserlistState Widget build, all Members statelesswidget

class UserList extends StatefulWidget {
  static const String id = "MAIN";
  final AuthResult user;

  const UserList({Key key, this.user}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String name;
  List<String> usuarios = new List<String>();

  //loads all valid chats for the owner, meaning, a client started it first
  getAll() async {
    getdata();

    List<DocumentSnapshot> docs = new List<DocumentSnapshot>();
    QuerySnapshot variable = await Firestore.instance
        .collection(/*"messages"*/ "chats")
        .getDocuments();

    docs = variable.documents;

    for (DocumentSnapshot doc in docs) {
      if (doc.data["To"].toString() == name) {
        usuarios.add(doc.data["From"].toString());
      }
    }
  }

  //recovers active user data
  getdata() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.user.user.uid)
        .get();

    name = variable.data['name'];
  }

  final databaseReference = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  //Creates a chat from the client chat if it doesnt exist already and changes the screen to the active chat
  Future<void> change(String user1, String user2) async {
    bool crear = true;
    QuerySnapshot variable = await Firestore.instance
        .collection(/*"messages"*/ "chats")
        .getDocuments();
    for (DocumentSnapshot doc in variable.documents) {
      if (doc.data["From"] == user1 && doc.data["To"] == user2) {
        crear = false;
      }
    }
    if (crear) {
      await databaseReference.collection('chats').add({
        'From': user1,
        'To': user2,
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user1: user1,
          user2: user2,
          current: name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getAll(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text("User Select " + name),
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Active owner chats"),
                    Expanded(
                      //Owner generated list start
                      child: StreamBuilder<QuerySnapshot>(
                        builder: (context, snapshot) {
                          List<Widget> users = new List<Widget>();
                          //builds user chats button list for owners
                          users = usuarios
                              .map((user) => Members(
                                    user: user,
                                    current: name,
                                  ))
                              .toList();
                          return ListView(
                            controller: scrollController,
                            children: <Widget>[
                              ...users,
                            ],
                          );
                        },
                      ),
                    ), //Owner generated list end
                    Text(
                        "Chat Start button for the customers"), //Start for the hard buttons for client chat start
                    FlatButton(
                        color: Colors.orange,
                        child: Text("U1"),
                        onPressed: () async {
                          await change(name, "U1");
                        }),
                    FlatButton(
                        color: Colors.orange,
                        child: Text("U2"),
                        onPressed: () async {
                          await change(name, "U2");
                        }),
                    FlatButton(
                        color: Colors.orange,
                        child: Text("U3"),
                        onPressed: () async {
                          await change(name, "U3");
                        }), //End for the hardbuttons for client chat start
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}

class Members extends StatelessWidget {
  final String user;
  final String current;

  Members({
    Key key,
    this.user,
    this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
              color: Colors.orange,
              child: Text(user),
              onPressed: () async {
                await change(current, user, context);
              }),
        ],
      ),
    );
  }

  //Changes page to the active chat
  Future<void> change(String user1, String user2, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user1: user2,
          user2: user1,
          current: current,
        ),
      ),
    );
  }
}
