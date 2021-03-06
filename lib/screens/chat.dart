import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final String user1;
  final String user2;
  final String current;

  const Chat({Key key, this.user1, this.user2, this.current}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  //creates a new message, errases the inputtext and moves the screen downards
  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('messages').add({
        'text': messageController.text,
        'User1': widget.user1,
        'User2': widget.user2,
        'date': DateTime.now().toIso8601String().toString(),
        'Author': widget.current,
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        title: Text(widget.user1),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              //creates list messages
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  List<DocumentSnapshot> filtered =
                      new List<DocumentSnapshot>();
                  List<Widget> messages;
                  //filters all unrealted messages
                  for (DocumentSnapshot doc in docs) {
                    if ((doc.data['User1'].toString() == widget.user1 &&
                        doc.data['User2'].toString() == widget.user2)) {
                      filtered.add(doc);
                    }
                  }
                  //generates chat messages list
                  messages = filtered
                      .map((doc) => Message(
                            user1: doc.data['User1'],
                            user2: doc.data['User2'],
                            text: doc.data['text'],
                            me: doc.data['Author'] == widget.current,
                            author: doc.data['Author'],
                            date: doc.data['date'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              //area for input text and send button
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SendButton(
                    text: "Enviar",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Theme.of(context).secondaryHeaderColor,
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: callback,
    );
  }
}

String convertDateFromString(String strDate) {
  final DateTime parsedDate = DateTime.parse(strDate);
  final DateFormat formatter = DateFormat('HH:mm');
  final String formatted = formatter.format(parsedDate);
  return formatted;
}

class Message extends StatelessWidget {
  final String user1;
  final String user2;
  final String text;
  final String author;
  final bool me;
  final String date;
  const Message(
      {Key key,
      this.user1,
      this.user2,
      this.text,
      this.me,
      this.author,
      this.date})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: //if im the author then align right, else align left
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            convertDateFromString(date),
          ),
          Material(
            // same but for colors
            color: me ? Colors.blue : Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}
