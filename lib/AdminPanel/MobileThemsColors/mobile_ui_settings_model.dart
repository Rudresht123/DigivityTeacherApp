import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/hex_color.dart';
import 'package:flutter/material.dart';

class MobileUiSettings {
  final List<Color>? graphColors;
  final Color? appBarColor;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? bottomSheetBgColor;
  final Color? appbarIconColor;
  final Color? bottombarIconColor;
  final Color? buttonColor;
  final Color? inputBorderColor;
  final Color? screenBackgroundColor;
  final String? screenBackgroundImage;

  MobileUiSettings({
    this.graphColors,
    this.appBarColor,
    this.iconColor,
    this.iconBgColor,
    this.bottomSheetBgColor,
    this.appbarIconColor,
    this.bottombarIconColor,
    this.buttonColor,
    this.inputBorderColor,
    this.screenBackgroundColor,
    this.screenBackgroundImage,
  });

  factory MobileUiSettings.fromJson(Map<String, dynamic> json) {
    final graphColorRaw = json['graph_color'] ?? '';
    final graphColorList = (graphColorRaw as String)
        .split('@')
        .where((e) => e.isNotEmpty)
        .map((e) => HexColor.fromHex(e))
        .toList();

    Color? safeColor(String? hex) {
      return (hex != null && hex.isNotEmpty) ? HexColor.fromHex(hex) : null;
    }

    return MobileUiSettings(
      graphColors: graphColorList.isNotEmpty ? graphColorList : [Colors.blue, Colors.green],
      appBarColor: safeColor(json['app_bar']),
      iconColor: safeColor(json['icon_color']),
      iconBgColor: safeColor(json['icon_bg_color']),
      bottomSheetBgColor: safeColor(json['bottom_sheet_bg_color']),
      appbarIconColor: safeColor(json['appbar_icon_color']),
      bottombarIconColor: safeColor(json['bottombar_icon_color']),
      buttonColor: safeColor(json['button_color']),
      inputBorderColor: safeColor(json['input_border_color']),
      screenBackgroundColor: safeColor(json['screen_background_color']),
      screenBackgroundImage: json['screen_background_image'],
    );
  }
}
