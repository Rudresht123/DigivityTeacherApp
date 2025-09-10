import 'package:flutter/material.dart';

class CustomSliderButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomSliderButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Colors.lightBlue.shade100
            : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.black : Colors.black87),
      ),
    );
  }
}
