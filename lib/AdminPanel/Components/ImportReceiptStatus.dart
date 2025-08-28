import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class ImportReceiptStatus extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? lable;
  const ImportReceiptStatus({super.key, this.onChanged,this.lable});

  @override
  State<ImportReceiptStatus> createState() => _ImportReceiptStatus();
}

class _ImportReceiptStatus extends State<ImportReceiptStatus> {
  String? receiptstatus;

  final List<Map<String, String>> receiptstatus_list = [
    {'id': '', 'receipt_status': 'Please Select Receipt Status'},
    {'id': 'paid', 'receipt_status': 'Paid'},
    {'id': 'unpaid', 'receipt_status': 'Unpaid'},
    {'id': 'cancel', 'receipt_status': 'Cancel'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomDropdown(
        items: receiptstatus_list,
        displayKey: 'receipt_status',
        valueKey: 'id',
        value: receiptstatus,
        onChanged: (val) {
          setState(() {
            receiptstatus = val;
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
