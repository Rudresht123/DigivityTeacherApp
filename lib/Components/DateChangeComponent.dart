import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChangeComonent extends StatefulWidget {
  final String? selectedDate;
  final VoidCallback? onTap;
  DateChangeComonent({Key? key, required this.selectedDate, this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _DateChangeComonent();
  }
}

class _DateChangeComonent extends State<DateChangeComonent> {
  DateTime selectedDate = DateTime.now();

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat("EEE, dd MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _changeDate(-1);
            },
          ),
        ),
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
            _formatDate(selectedDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _changeDate(1);
            },
          ),
        ),
      ],
    );
  }
}
