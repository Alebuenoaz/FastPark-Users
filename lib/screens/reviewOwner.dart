import 'package:fast_park/models/parking.dart';
import 'package:fast_park/models/review.dart';
import 'package:fast_park/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ReviewOwner extends StatefulWidget {
  @override
  _ReviewOwnerState createState() => _ReviewOwnerState();
}

class _ReviewOwnerState extends State<ReviewOwner> {
  final db = FirestoreServ();
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(context),
      );
    } else {
      return Scaffold(
        body: cuerpo(context),
      );
    }
  }

  Widget cuerpo(context) {
    var user = Provider.of<FirebaseUser>(context);
    return Column(
      children: <Widget>[
        StreamProvider<List<Parking>>.value(
            value: db.streamParking(user), child: PalkingList()),
      ],
    );
  }
}

class PalkingList extends StatelessWidget {
  final db = FirestoreServ();

  @override
  Widget build(BuildContext context) {
    //final reviews = Provider.of<List<Review>>(context);
    var parkings = Provider.of<List<Parking>>(context);

    return Container(
      height: 300,
      child: StreamProvider<List<Review>>.value(
        value: db.streamReview(parkings[0].documentID),
        child: (parkings != null)
            ? ReviewList()
            : Center(child: CircularProgressIndicator()),
      ),
    );
    //);
  }
}

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var reviews = Provider.of<List<Review>>(context);
    return Container(
        height: 300,
        child: (reviews != null)
            ? ListView(
                children: reviews.map((review) {
                  //itemCount: reviews.length,
                  //itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      //Text(review.img, style: TextStyle(fontSize: 50)),
                      title: Text(review.userID),
                      subtitle: //Text(review.description),
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 3.0,
                          ),
                          //(places[index].rating != null)
                          (true)
                              ? Row(
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
                              : Row(),
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
