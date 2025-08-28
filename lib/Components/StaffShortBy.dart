import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class Staffshortby extends StatefulWidget {
  final Function(String?)? onChanged; // ✅ Parent callback
  final String? lable;
  const Staffshortby({super.key, this.onChanged,this.lable}); // ✅ Constructor

  @override
  State<Staffshortby> createState() => _Staffshortby();
}

class _Staffshortby extends State<Staffshortby> {
  String? studentshortby;

  final List<Map<String, String>> shortByType = [
    {'id': '', 'short_by': 'Staff Short By'},
    {'id': 'staff_no', 'short_by': 'Staff No'},
    {'id': 'staff_name', 'short_by': 'Staff Name'},
    {'id': 'contact_no', 'short_by': 'Mobile No.'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: shortByType,
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
