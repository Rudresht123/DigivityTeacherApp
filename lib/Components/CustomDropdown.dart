import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDropdown extends StatefulWidget {
  final List<dynamic> items;
  final String displayKey;
  final String valueKey;
  final String hint;
  final Function(dynamic) onChanged;
  final dynamic selectedValue;
  final dynamic value;
  final String? label;
  final Function(dynamic)? validator;
  final Map<String, dynamic> Function(dynamic)? itemMapper;
  const CustomDropdown({
    Key? key,
    required this.items,
    required this.displayKey,
    required this.valueKey,
    required this.onChanged,
    required this.hint,
    this.selectedValue,
    this.value,
    this.validator,
    this.itemMapper,
    this.label
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  dynamic _selectedValue;

  List<Map<String, dynamic>> get mappedItems {
    return widget.items.map<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic>) return item;
      if (widget.itemMapper != null) return widget.itemMapper!(item);
      throw Exception("Provide itemMapper for non-Map types");
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    final initialValue = widget.selectedValue ?? widget.value;
    _selectedValue = getValidValue(initialValue);

    if (_selectedValue == null && mappedItems.isNotEmpty) {
      _selectedValue = mappedItems.first[widget.valueKey];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(_selectedValue);
      });
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.selectedValue ?? widget.value;
    if (newValue != oldWidget.selectedValue || widget.items != oldWidget.items) {
      setState(() {
        _selectedValue = getValidValue(newValue);
      });
    }
  }

  dynamic getValidValue(dynamic value) {
    final validIds = mappedItems.map((e) => e[widget.valueKey]).toSet();
    return (value == null || validIds.contains(value)) ? value : null;
  }

  @override
  Widget build(BuildContext context) {

    final uiTheme = Provider.of<UiThemeProvider>(context);
    return DropdownButtonFormField<dynamic>(
      value: getValidValue(_selectedValue),
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.label ?? widget.hint,
        hintText: widget.hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: uiTheme.inputBorderColor ?? Colors.grey.shade400,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: uiTheme.inputBorderColor ?? Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      selectedItemBuilder: (context) {
        return mappedItems.map((item) {
          final text = item[widget.displayKey]?.toString() ?? '';
          final count = item['count'];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              if (count != null)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          );
        }).toList();
      },
      items: mappedItems.map((item) {
        final text = item[widget.displayKey]?.toString() ?? '';
        final count = item['count'];

        return DropdownMenuItem<dynamic>(
          value: item[widget.valueKey],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              if (count != null)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
      validator: widget.validator != null ? (val) => widget.validator!(val) : null,
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
