import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class Statusdropdown extends StatefulWidget {
  final Function(String?)? onChange;
  final String? label;
  const Statusdropdown({super.key, this.onChange,this.label});

  @override
  State<Statusdropdown> createState() => _StatusdropdownState();
}

class _StatusdropdownState extends State<Statusdropdown> {
  String? status;

  final List<Map<String, String>> studentstatus = [
    {'id': 'active', 'status': 'Active'},
    {'id': 'inactive', 'status': 'InActive'},
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: studentstatus,
        displayKey: 'status',
        valueKey: 'id',
        value: status,
        onChanged: (val) {
          setState(() {
            status = val;
          });

          if (widget.onChange != null) {
            widget.onChange!(val);
          }
        },
        hint: widget.label ?? 'Select a Option',
      ),
    );
  }
}
