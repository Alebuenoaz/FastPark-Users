import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

class Reservas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: cuerpo(),
      );
    } else {
      Scaffold(
        body: cuerpo(),
      );
    }
  }

  Widget cuerpo() {
    return Center(
      child: Text('Reservas'),
    );
  }
}
