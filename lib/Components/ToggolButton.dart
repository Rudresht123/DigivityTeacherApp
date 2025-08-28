import 'package:flutter/material.dart';

class TwoFAToggleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TwoFAToggleButton({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // 👈 Use InkWell instead of GestureDetector for better tap effect
      borderRadius: BorderRadius.circular(30),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey.shade600,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: value
              ? [
            const Text(
              'Enable',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            _customSwitch(value),
          ]
              : [
            _customSwitch(value),
            const SizedBox(width: 10),
            const Text(
              'Disable',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customSwitch(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 20,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
