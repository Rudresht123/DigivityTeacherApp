import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/ApisController/AddStudentFormData.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
class MulitipleSelectStudentType extends StatefulWidget {
  final List<String>? initialValues;
  final Function(List<String>)? onChanged;
  final String? Function(List<String>?)? validator;

  const MulitipleSelectStudentType({
    Key? key,
    this.initialValues,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<MulitipleSelectStudentType> createState() => _MulitipleSelectStudentType();
}

class _MulitipleSelectStudentType extends State<MulitipleSelectStudentType> {
  List<String> selectedCourses = [];
  StudentDataModel? studentFormData;
  List<MultiSelectItem<String>> items = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedCourses = List.from(widget.initialValues!);
    }
    _fetchStudentAdmissionType();
  }

  Future<void> _fetchStudentAdmissionType() async {
    final data = await AddStudentFormData().getStudentFormData();
    setState(() {
      studentFormData = data;
      items = studentFormData?.admType
          .map((e) => MultiSelectItem<String>(e.id.toString(), e.admission_type))
          .toList() ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField<String>(
          items: items,
          title: const Text("Admission Types"),
          selectedColor: Colors.blue,
          buttonText: const Text("Admission Types"),
          searchable: true,
          listType: MultiSelectListType.LIST,
          initialValue: selectedCourses,
          validator: widget.validator,
          onConfirm: (values) {
            setState(() {
              selectedCourses = values;
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
                selectedCourses.remove(value);
              });
              widget.onChanged?.call(selectedCourses);
            },
          ),
        ),
      ],
    );
  }
}
