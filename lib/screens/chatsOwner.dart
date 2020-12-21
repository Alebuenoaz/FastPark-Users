import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_park/models/usuarios.dart';
import 'package:fast_park/screens/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ChatsOwner extends StatelessWidget {
  String name;
  List<String> usuarios = new List<String>();

  getAll(String email) async {
    //getdata();
    usuarios.clear();
    name = email;
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
  /* getdata() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.user.user.uid)
        .get();

    name = variable.data['name'];
  }*/

  final databaseReference = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(),
      );
    } else {
      return (user != null)
          ? FutureBuilder<dynamic>(
              future: getAll(user.email), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else {
                    return Scaffold(
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
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            )
          : Center(child: CircularProgressIndicator());
    }
  }

  Widget cuerpo() {
    return Center(
      child: Text('Chats'),
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
