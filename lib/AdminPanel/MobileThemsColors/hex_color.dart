import 'package:flutter/material.dart';

class HexColor extends Color {
  static const Map<String, String> _namedColors = {
    'black': '#000000',
    'white': '#ffffff',
    'red': '#ff0000',
    'green': '#00ff00',
    'blue': '#0000ff',
    'grey': '#808080',
    'gray': '#808080',
    // Add more as needed
  };

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toLowerCase();

    // Convert named colors to hex
    if (_namedColors.containsKey(hexColor)) {
      hexColor = _namedColors[hexColor]!;
    }

    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static HexColor fromHex(String hexColor) {
    return HexColor(hexColor);
  }
}

