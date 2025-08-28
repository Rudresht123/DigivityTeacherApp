import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class Studentsortby extends StatefulWidget {
  final Function(String?)? onChanged; // ✅ Parent callback
  final String? lable;
  const Studentsortby({super.key, this.onChanged,this.lable}); // ✅ Constructor

  @override
  State<Studentsortby> createState() => _StudentsortbyState();
}

class _StudentsortbyState extends State<Studentsortby> {
  String? studentshortby;

  final List<Map<String, String>> shortby = [
    {'id': '', 'short_by': 'Please Select Short By'},
    {'id': 'asc', 'short_by': 'Ascending'},
    {'id': 'desc', 'short_by': 'Descending'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: shortby,
        displayKey: 'short_by',
        valueKey: 'id',
        value: studentshortby,
        onChanged: (val) {
          setState(() {
            studentshortby = val;
          });

          if (widget.onChanged != null) {
            widget.onChanged!(val);
          }
        },
        hint: widget.lable ?? 'Select a Option',
      ),
    );
  }
}
