import 'dart:ui';

import 'package:flutter/material.dart';

abstract class ColoresApp {
  static Color get amarillo {
    return const Color(0xFFe2a84b);
  }

  static Color get grisoscuro {
    return const Color(0xFF4e5b60);
  }

  static Color get grisclaro {
    return const Color(0xFFc8d6ef);
  }

  static Color get azuloscuro {
    return const Color(0xFF263a44);
  }

  static Color get azulclaro {
    return const Color(0xFF48a1af);
  }

  static Color get naranja {
    return const Color(0xFFFF9100);
  }

  static MaterialColor get naranjaMaterial {
    return const MaterialColor(0xFFFF9100, <int, Color>{
      50: Color.fromRGBO(255, 145, 0, .1),
      100: Color.fromRGBO(255, 145, 0, .2),
      200: Color.fromRGBO(255, 145, 0, .3),
      300: Color.fromRGBO(255, 145, 0, .4),
      400: Color.fromRGBO(255, 145, 0, .5),
      500: Color.fromRGBO(255, 145, 0, .6),
      600: Color.fromRGBO(255, 145, 0, .7),
      700: Color.fromRGBO(255, 145, 0, .8),
      800: Color.fromRGBO(255, 145, 0, .9),
      900: Color.fromRGBO(255, 145, 0, 1),
    });
  }

  static MaterialColor get black {
    return const MaterialColor(0xFF000000,<int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });
  }

  static MaterialColor get white {
    return const MaterialColor(0xFFFFFFFF,<int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  });
  }

  static Color get rojo {
    return const Color(0xFFee5253);
  }

  static Color get verde {
    return const Color(0xFF3b7d02);
  }

  static Color get azulFacebook {
    return const Color(0xFF3b5996);
  }

  static Color get rojoGoogle {
    return const Color(0xFFD32F2F);
  }

  static Color get naranjaClaro {
    return const Color(0xFFFFcd85);
  }
}
