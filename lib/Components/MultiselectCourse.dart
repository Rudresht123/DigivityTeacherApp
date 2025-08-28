import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';

class MultiselectCourse extends StatefulWidget {
  final List<String>? initialValues;
  final Function(List<String>)? onChanged;
  final String? Function(List<String>?)? validator;

  const MultiselectCourse({
    Key? key,
    this.initialValues,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<MultiselectCourse> createState() => _MultiselectCourseState();
}

class _MultiselectCourseState extends State<MultiselectCourse> {
  List<String> selectedCourses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      selectedCourses = List.from(widget.initialValues!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    final rawList = dashboardProvider.courseDropdownMap ?? [];

    final List<MultiSelectItem<String>> items = rawList.map((e) {
      final courseId = e['id']?.toString() ?? '';
      final courseValue = e['value']?.toString() ?? 'Unknown';
      return MultiSelectItem<String>(courseId, courseValue);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField<String>(
          items: items,
          title: const Text("Select Courses"),
          selectedColor: Colors.blue,
          buttonText: const Text("Choose Courses"),
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
            textStyle: const TextStyle(color: Colors.black),
            chipColor: Colors.blue.shade100,
            onTap: (value) {
              setState(() {
                selectedCourses.remove(value);
              });
              widget.onChanged?.call(selectedCourses);
            },
            items: selectedCourses.map((id) {
              final course = rawList.firstWhere(
                    (e) => e['id']?.toString() == id,
                orElse: () => {'value': 'Unknown'},
              );
              return MultiSelectItem<String>(
                id,
                course['value']?.toString() ?? 'Unknown',
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
