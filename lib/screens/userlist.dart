import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserList extends StatefulWidget {
  static const String id = "MAIN";
  final AuthResult user;

  const UserList({Key key, this.user}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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
        return User.fromSnapshot(snapshot);
      } catch (e) {
        print(e);
        return null;
      }
    });
    return user;
  }

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await databaseReference.collection('messages').add({
        'text': messageController.text,
        'from': widget.user.user.email,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _getUser(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              appBar: AppBar(
                title: Text("User Select"),
              ),
              /*
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            databaseReference.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          List<DocumentSnapshot> docs = snapshot.data.documents;
                          //problem handling listview inside futture builder, map with (doc){} solves but renders nothing
                          List<Widget> members = docs
                              .map((doc) => Members(
                                    //from: doc.data['from'],
                                    text: doc.data['name'],
                                    uid: widget.user.user.email,
                                    uid2: doc.documentID,
                                    //me: widget.user.user.email ==
                                    //   doc.data['from'],
                                  ))
                              .toList();
                          //posible solution> use ListView.builder, but dont know how to
                          return ListView(
                            controller: scrollController,
                            children: <Widget>[
                              ...members,
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),*/
            );
        }
      },
    );
  }
}

class Members extends StatelessWidget {
  //final String from;
  final String text;
  final String uid;
  final String uid2;
  final databaseReference = Firestore.instance;

  //final bool me;

  Members({
    Key key,
    /* this.from,*/
    this.text,
    this.uid,
    this.uid2,
    /* this.me*/
  }) : super(key: key);

  _createRecord(String uid1, String uid2) async {
    bool exists = false;
    QuerySnapshot chats =
        await databaseReference.collection("chats").getDocuments();

    for (var docs in chats.documents) {
      if (docs.data["User1"] == uid1 || docs.data["User2"] == uid2) {
        exists = true;
      }
    }

    if (!exists) {
      await databaseReference
          .collection("chats")
          .document()
          .setData({'User1': uid, 'User2': uid2});
    }

    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: user,
        ),
      ),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: _createRecord(uid, uid2),
      child: Text(text),
    );
  }
}
