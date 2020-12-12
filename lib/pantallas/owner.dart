import 'dart:async';
import 'dart:io';
import 'package:fastpark/blocs/autenticacion.dart';
import 'package:fastpark/design/colores.dart';
import 'package:fastpark/pantallas/chats.dart';
import 'package:fastpark/pantallas/cuenta.dart';
import 'package:fastpark/pantallas/reservas.dart';
import 'package:fastpark/widget/barra.dart';
import 'package:fastpark/widget/owner_scaf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Owner extends StatefulWidget {
  StreamSubscription _usuarioSubs;

  @override
  _OwnerState createState() => _OwnerState();

  static TabBar get ownerTabBar {
    return TabBar(
      unselectedLabelColor: ColoresApp.grisclaro,
      labelColor: ColoresApp.naranjaClaro,
      indicatorColor: ColoresApp.naranja,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.chat_bubble_outline)),
        Tab(icon: Icon(Icons.drive_eta_outlined)),
        Tab(icon: Icon(Icons.perm_identity)),
      ],
    );
  }
}

class _OwnerState extends State<Owner> {
  @override
  //manera donde valida si el init/dispose estan bien
  void initState() {
    Future.delayed(Duration.zero, () {
      var autenticacion = Provider.of<Autenticacion>(context, listen: false);
      widget._usuarioSubs = autenticacion.user.listen((user) {
        if (user == null)
          Navigator.of(context)
              .pushNamedAndRemoveUntil('./loginFP', (route) => false);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget._usuarioSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              Barra.cupertinoBarra(title: 'Vista dueño', context: context),
            ];
          },
          body: OwnerScaff.cupertinoTabScaffold,
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                Barra.androidBarra(
                    title: 'Vista dueño', tabBar: Owner.ownerTabBar)
              ];
            },
            body: TabBarView(
              children: <Widget>[
                Chats(),
                Reservas(),
                Cuenta(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
