import 'package:fast_park/models/parking.dart';
import 'package:fast_park/models/review.dart';
import 'package:fast_park/models/user.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ReviewWidget extends StatefulWidget {
  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var parkings = Provider.of<List<Parking>>(context);
    return Container(
        //child: SingleChildScrollView(
        child: StreamProvider<List<Review>>.value(
      value: db.streamReview(parkings[0].documentID),
      child: (parkings != null)
          ? ParkingList()
          : Center(
              child: CircularProgressIndicator(),
            ),
    )
        //),
        );
  }
}

class ParkingList extends StatelessWidget {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    var reviews = Provider.of<List<Review>>(context);
    return Container(
      height: 300,
      //child: SingleChildScrollView(
      child: StreamProvider<List<User>>.value(
        value: db.streamUsers(),
        child: (reviews != null)
            ? ReviewList()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      //),
    );
  }
}

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var reviews = Provider.of<List<Review>>(context);
    var users = Provider.of<List<User>>(context);
    /*users.forEach((element) {
      print(element.nombre);
    });*/
    return Container(
        height: 300,
        child: (users != null)
            ? ListView(
                children: reviews.map((review) {
                  User currentUser = userFromReview(users, review.userID);
                  //itemCount: reviews.length,
                  //itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      //Text(review.img, style: TextStyle(fontSize: 50)),
                      title:
                          Text(currentUser.nombre + ' ' + currentUser.apellido),
                      subtitle: //Text(review.description),
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(currentUser.email),
                          SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            children: <Widget>[
                              RatingBarIndicator(
                                rating: double.parse(review.value),
                                itemBuilder: (context, index) =>
                                    Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 10.0,
                                direction: Axis.horizontal,
                              )
                            ],
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                }).toList(),
              )
            : Center(child: CircularProgressIndicator()));
  }
}

User userFromReview(List<User> users, String uid) {
  return //users[0].nombre ?? ''; //(users != null) ? users[0].nombre : '';
      users.firstWhere((user) => user.userId == uid);
}
