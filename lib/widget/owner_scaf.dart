import 'package:fastpark/design/colores.dart';
import 'package:fastpark/pantallas/chats.dart';
import 'package:fastpark/pantallas/cuenta.dart';
import 'package:fastpark/pantallas/reservas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class OwnerScaff {
  //iOS
  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTab,
      tabBuilder: (context, index) {
        return _eleccion(index);
      },
    );
  }

  static get _cupertinoTab {
    return CupertinoTabBar(
      backgroundColor: ColoresApp.naranjaClaro,
      items: <BottomNavigationBarItem>[
        // ignore: deprecated_member_use
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            // ignore: deprecated_member_use
            title: Text('Chats')),
        // ignore: deprecated_member_use
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.car_detailed),
            // ignore: deprecated_member_use
            title: Text('Reservas')),
        // ignore: deprecated_member_use
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            // ignore: deprecated_member_use
            title: Text('Cuenta'))
      ],
    );
  }

  static Widget _eleccion(int index) {
    if (index == 0) {
      return Chats();
    }

    if (index == 1) {
      return Reservas();
    }

    if (index == 2) {
      return Cuenta();
    }
  }

  //Android

}
