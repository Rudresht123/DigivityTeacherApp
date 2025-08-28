import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final double? width;
  final int? maxline;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;


  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.width = double.infinity,
    this.maxline,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: TextFormField(
        maxLines: maxline,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: uiTheme.inputBorderColor ?? Colors.blue, // dynamic color
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(3),
          ),

          // Enabled (unfocused) border
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: uiTheme.inputBorderColor ?? Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),

          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical:  (maxline ?? 1) > 1 ? 20 : 0,
        ),
        ),
      ),
    );
  }
}
