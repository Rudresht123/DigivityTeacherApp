import 'package:flutter/material.dart';

class IconBg{
  static Widget buildSidebarIcon(
      IconData iconData, {
        Color bgColor = const Color(0xFFE5E6FA),
        Color iconColor = Colors.blue,
      }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 18,
      ),
    );
  }
}
