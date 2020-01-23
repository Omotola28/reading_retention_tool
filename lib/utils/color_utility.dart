import 'package:flutter/material.dart' show Color;

class HexColor extends Color {

  static int _getColorFromHex(String hexColor) {

    int color;

    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      color = int.parse("0x$hexColor");
    }

    return color;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}