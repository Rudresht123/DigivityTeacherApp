import 'package:flutter/material.dart';

class FieldSet extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets innerPadding;

  const FieldSet({
    Key? key,
    required this.title,
    required this.child,
    this.innerPadding = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 6) + innerPadding,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: child,
          ),
          Positioned(
            left: 16,
            top: 0,
            child: Container(
              color: Colors.white, // background must match the parent container
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
