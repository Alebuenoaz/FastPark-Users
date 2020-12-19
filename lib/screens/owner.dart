import 'dart:async';

import 'package:fast_park/providers/autenticacion.dart';
import 'package:fast_park/design/barraDes.dart';
import 'package:fast_park/screens/parkingOwner.dart';
import 'package:fast_park/screens/reservasOwner.dart';
import 'package:fast_park/screens/reviewOwner.dart';
import 'package:fast_park/widget/barra.dart';
import 'package:fast_park/widget/owner_scaf.dart';
import 'package:fast_park/screens/cuenta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Owner extends StatefulWidget {
  StreamSubscription _userSub;

  @override
  _OwnerState createState() => _OwnerState();

  static TabBar get ownerTabBar {
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
}

class _OwnerState extends State<Owner> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var autenticacion = Provider.of<Autenticacion>(context, listen: false);

      widget._userSub = autenticacion.user.listen((user) {
        if (user == null)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/loginFP', (route) => false);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._userSub.cancel();
    super.dispose();
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
            body: OwnerScaff.cupertinoTabScaffold),
      );
    } else {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxScroll) {
              return <Widget>[
                Barra.androidBarra(
                    title: 'FastPark!', tabBar: Owner.ownerTabBar)
              ];
            },
            body: TabBarView(
              children: <Widget>[
                //ParqueosOwner(),
                ParkingOwner(),
                //ChatsOwner(),
                ReviewOwner(),
                ReservasOwner(),
                Cuenta(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
