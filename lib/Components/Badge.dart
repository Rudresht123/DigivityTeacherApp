import 'package:flutter/material.dart';

class BadgeScreen extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSize;
  final IconData? icon; // optional icon
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const BadgeScreen({
    Key? key,
    required this.text,
    required this.color,
    this.icon,
    this.textStyle,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize ?? 10, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style:
                textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
