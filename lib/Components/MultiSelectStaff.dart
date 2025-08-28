import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/ApisController/AddStudentFormData.dart';
import 'package:digivity_admin_app/ApisController/StaffApis.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectStaff extends StatefulWidget {
  final List<String>? initialValues;
  final Function(List<String>)? onChanged;
  final String? Function(List<String>?)? validator;

  const MultiSelectStaff({
    Key? key,
    this.initialValues,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<MultiSelectStaff> createState() => _MultiSelectStaff();
}

class _MultiSelectStaff extends State<MultiSelectStaff> {
  List<String> selectedStaffs = [];
  StaffModel? staffdata;
  List<MultiSelectItem<String>> items = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedStaffs = List.from(widget.initialValues!);
    }
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    final response = await StaffApis().getStaffList();
    if (response != null && response != null) {
      setState(() {
        items = response
            .map<MultiSelectItem<String>>(
              (staff) => MultiSelectItem(
            staff.dbId!.toString(),
            '${staff.fullName!} (${staff.designation ?? "N/A"})',
          ),
        )
            .toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField<String>(
        items: items,
          title: const Text("Authorize By"),
          selectedColor: Colors.blue,
          buttonText: const Text("Authorize By"),
          searchable: true,
          listType: MultiSelectListType.LIST,
          initialValue: selectedStaffs,
          validator: widget.validator,
          onConfirm: (values) {
            setState(() {
              selectedStaffs = values;
            });
            widget.onChanged?.call(values);
          },
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade500,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          buttonIcon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          chipDisplay: MultiSelectChipDisplay(
            chipColor: Colors.blue.shade100,
            textStyle: const TextStyle(color: Colors.black),
            onTap: (value) {
              setState(() {
                selectedStaffs.remove(value);
              });
              widget.onChanged?.call(selectedStaffs);
            },
          ),
        ),
      ],
    );
  }
}
