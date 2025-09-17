import 'package:digivity_admin_app/ApisController/StaffApis.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:flutter/material.dart';

class StaffDropdown extends StatefulWidget {
  final Function(dynamic) onChange;
  final Function(dynamic)? validator;
  final String? selectedvalue;
  final String? label; // just one selected value
  const StaffDropdown({Key? key,this.label,required this.onChange,this.validator,this.selectedvalue})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => _StaffDropdownState();
}

class _StaffDropdownState extends State<StaffDropdown> {
  List<Map<String, dynamic>> staffItems = [];
  String? selectedStaff;

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    try {
      final response = await StaffApis().getStaffList(); // List<StaffModel>
      setState(() {
        setState(() {
          staffItems = [
            {"id": "", "fullName": "Please Select Staff"}, // default first item
            ...response
                .map(
                  (staff) => {
                    "id": staff.dbId.toString(), // ensure String
                    "fullName": staff.fullName ?? "", // ensure String
                  },
                )
                .toList(),
          ];
        });
      });
    } catch (e) {
      staffItems = [];
      print("Error fetching staff: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return staffItems.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : CustomDropdown(
             selectedValue: widget.selectedvalue ?? selectedStaff,
            label: widget.label ?? "Select Host",
            items: staffItems,
            validator: widget.validator,
            displayKey: "fullName",
            valueKey: "id",
            onChanged:
                widget.onChange,
            hint: "Select Host",
          );
  }
}
