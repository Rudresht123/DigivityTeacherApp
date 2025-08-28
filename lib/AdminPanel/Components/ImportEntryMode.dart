import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class ImportEntryMode extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? lable;
  const ImportEntryMode({super.key, this.onChanged,this.lable});

  @override
  State<ImportEntryMode> createState() => _ImportEntryMode();
}

class _ImportEntryMode extends State<ImportEntryMode> {
  String? entrymode;

  final List<Map<String, String>> entrymodellist = [
    {'id': '', 'entry_mode': 'Please Select Entry Mode'},
    {'id': 'school', 'entry_mode': 'School'},
    {'id': 'online', 'entry_mode': 'Online'},
    {'id': 'bank', 'entry_mode': 'Bank'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: entrymodellist,
        displayKey: 'entry_mode',
        valueKey: 'id',
        value: entrymode,
        onChanged: (val) {
          setState(() {
            entrymode = val;
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
