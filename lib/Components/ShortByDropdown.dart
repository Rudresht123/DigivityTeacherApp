import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class ShortByDropdown extends StatefulWidget {
  final Function(String?)? onChanged; // 👈 Add this
final String? label;
  const ShortByDropdown({super.key, this.onChanged,this.label}); // 👈 Add this constructor param

  @override
  State<ShortByDropdown> createState() => _ShortByDropdownState();
}

class _ShortByDropdownState extends State<ShortByDropdown> {
  String? studentShortBy;

  final List<Map<String, String>> shortby = [
    {'id': '', 'short_by': 'Please Select Shortby'},
    {'id': 'roll_no', 'short_by': 'Roll No.'},
    {'id': 'admission_no', 'short_by': 'Admission No.'},
    {'id': 'first_name', 'short_by': 'First Name'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: shortby,
        displayKey: 'short_by',
        valueKey: 'id',
        value: studentShortBy,
        onChanged: (val) {
          setState(() {
            studentShortBy = val;
          });

          if (widget.onChanged != null) {
            widget.onChanged!(val); // 👈 Fire parent callback
          }
        },
        hint: widget.label ?? 'Select a Option',
      ),
    );
  }
}
