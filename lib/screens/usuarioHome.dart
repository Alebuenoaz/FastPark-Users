import 'dart:io';

import 'package:fast_park/screens/location.dart';
import 'package:fast_park/screens/searchMap.dart';
import 'package:fast_park/screens/chatUsuario.dart';
import 'package:fast_park/screens/cuentaUsuario.dart';
import 'package:fast_park/widget/barra.dart';
import 'package:fast_park/widget/usuario_scaf.dart';
import 'package:fast_park/design/barraDes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeUsuario extends StatelessWidget {
  static TabBar get userTabBar {
    return TabBar(
      unselectedLabelColor: BarraDes.unselectedLabelColor,
      labelColor: BarraDes.selectedLabelColor,
      indicatorColor: BarraDes.indicator,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.location_on_outlined)),
        Tab(icon: Icon(Icons.chat_bubble_outline)),
        Tab(icon: Icon(Icons.drive_eta)),
        Tab(icon: Icon(Icons.person_outline)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool boxScroll) {
            return <Widget>[
              Barra.cupertinoBarra(title: 'FastPark!', context: context),
            ];
          },
          body: UsuarioScaff.cupertinoTabScaffoldUser,
        ),
      );
    } else {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxScroll) {
              return <Widget>[
                Barra.androidBarra(
                    title: 'FastPark!', tabBar: HomeUsuario.userTabBar)
              ];
            },
            body: TabBarView(
              children: <Widget>[
                SearchMap(),
                LocationMap(),
                ChatsUsuario(),
                CuentaUsuario(),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class ChatUsuario {}
