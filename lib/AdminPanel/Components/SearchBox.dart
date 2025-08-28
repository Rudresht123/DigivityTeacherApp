import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSearch;
  final Function(String)? onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final uiTheme = Provider.of<UiThemeProvider>(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: uiTheme.inputBorderColor ?? Colors.grey),
        ),
      ),
    );
  }
}
