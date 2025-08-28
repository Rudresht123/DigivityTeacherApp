import 'package:flutter/material.dart';

class AttendanceStatusButton extends StatefulWidget {
  final Function(String) onStatusChanged;
  final String? initialStatus;

  const AttendanceStatusButton({
    super.key,
    required this.onStatusChanged,
    this.initialStatus,
  });

  @override
  State<AttendanceStatusButton> createState() => _AttendanceStatusButtonState();
}

class _AttendanceStatusButtonState extends State<AttendanceStatusButton> {
  final List<String> _statuses = ['P', 'A', 'LT', 'LV'];
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialStatus != null && _statuses.contains(widget.initialStatus)
        ? _statuses.indexOf(widget.initialStatus!)
        : 0;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'P':
        return Colors.green;
      case 'A':
        return Colors.red;
      case 'LT':
        return Colors.orange;
      case 'LV':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _toggleStatus() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _statuses.length;
    });

    widget.onStatusChanged(_statuses[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = _statuses[_currentIndex];

    return GestureDetector(
      onTap: _toggleStatus,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getStatusColor(currentStatus),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          currentStatus,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
