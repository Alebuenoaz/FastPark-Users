import 'dart:ui';
import 'package:fastpark/design/colores.dart';

abstract class BarraDes {
  static Color get unselectedLabelColor {
    return ColoresApp.naranjaClaro;
  }

  static Color get selectedLabelColor {
    return ColoresApp.naranja;
  }

  static Color get indicator {
    return ColoresApp.naranja;
  }
}
