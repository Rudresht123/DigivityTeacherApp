import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final FormFieldValidator<String>? validator;

  const DatePickerField({
    Key? key,
    this.controller,
    this.label,
    this.validator,
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
    if (_localController.text.isEmpty) {
      _localController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_localController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _localController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {});
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
        labelText: widget.label, // 👈 Shows label inside border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: uiTheme.inputBorderColor ?? Colors.blue, // dynamic color
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        // Enabled (unfocused) border
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
