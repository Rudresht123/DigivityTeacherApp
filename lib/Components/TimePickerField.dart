import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Timepickerfield extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final FormFieldValidator<String>? validator;

  const Timepickerfield({
    Key? key,
    this.controller,
    this.label,
    this.validator,
  }) : super(key: key);

  @override
  _TimepickerfieldState createState() => _TimepickerfieldState();
}

class _TimepickerfieldState extends State<Timepickerfield> {
  late TextEditingController _localController;

  @override
  void initState() {
    super.initState();
    _localController = widget.controller ?? TextEditingController();
    if (_localController.text.isEmpty) {
      final now = TimeOfDay.now();
      _localController.text = _formatTime(now);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      _localController.text = _formatTime(pickedTime);
      setState(() {});
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt); // e.g., 5:08 PM
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    return TextFormField(
      controller: _localController,
      validator: widget.validator,
      readOnly: true,
      onTap: _selectTime,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.label ?? 'Select Time',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: uiTheme.inputBorderColor ?? Colors.blue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: uiTheme.inputBorderColor ?? Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
