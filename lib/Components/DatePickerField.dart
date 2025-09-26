import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final FormFieldValidator<String>? validator;
  final void Function(DateTime)? onDateSelected; // 👈 callback

  const DatePickerField({
    Key? key,
    this.controller,
    this.label,
    this.validator,
    this.onDateSelected,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _localController;

  @override
  void initState() {
    super.initState();
    _localController = widget.controller ?? TextEditingController();

    // Set default text if empty
    if (_localController.text.isEmpty) {
      _localController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate;

    // parse current text safely
    try {
      initialDate = DateFormat('dd-MM-yyyy').parse(_localController.text);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _localController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {});

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    return TextFormField(
      controller: _localController,
      validator: widget.validator,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(
          color: uiTheme.inputBorderColor ?? Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 16,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
