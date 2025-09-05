import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChangeComonent extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateChanged;

  const DateChangeComonent({
    Key? key,
    required this.selectedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateChangeComonent();
}

class _DateChangeComonent extends State<DateChangeComonent> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    widget.onDateChanged?.call(_selectedDate);
  }

  String _formatDate(DateTime date) {
    return DateFormat("EEE, dd MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildArrowButton(Icons.arrow_back, -1),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.09,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _formatDate(_selectedDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        _buildArrowButton(Icons.arrow_forward, 1),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, int days) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(icon: Icon(icon), onPressed: () => _changeDate(days)),
    );
  }
}
