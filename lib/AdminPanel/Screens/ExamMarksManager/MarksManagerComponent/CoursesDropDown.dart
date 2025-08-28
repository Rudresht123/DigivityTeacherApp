import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/CourseModel.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';
import 'package:flutter/material.dart';

class CoursesDropdown extends StatefulWidget {
  final Function(String courseId, String courseName)? onCourseSelected;
  final VoidCallback? onFetchStarted;
  final VoidCallback? onFetchCompleted;

  const CoursesDropdown({
    Key? key,
    this.onCourseSelected,
    this.onFetchStarted,
    this.onFetchCompleted,
  }) : super(key: key);

  @override
  State<CoursesDropdown> createState() => _CoursesDropdownState();
}

class _CoursesDropdownState extends State<CoursesDropdown> {
  List<CourseModel> courseList = [];
  String? selectedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchInitialData());
  }

  Future<void> fetchInitialData() async {
    widget.onFetchStarted?.call(); // notify parent: fetching started

    try {
      final data = await StudentMarksManagerCommonHelper().getMarksmanagerData();
      if (data.isNotEmpty && data['courseList'] != null) {
        setState(() {
          courseList = List<CourseModel>.from(data['courseList']);
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      widget.onFetchCompleted?.call(); // notify parent: fetching complete
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: 'Grade/Class',
      selectedValue: selectedCourseId,
      items: courseList
          .map((e) => {'id': e.courseId, 'value': e.Course})
          .toList(),
      displayKey: 'value',
      valueKey: 'id',
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select a course' : null,
      onChanged: (value) {
        setState(() {
          selectedCourseId = value;
        });

        final selected = courseList.firstWhere(
              (e) => e.courseId == value,
          orElse: () => CourseModel(courseId: '', Course: ''),
        );

        widget.onCourseSelected?.call(value, selected.Course ?? '');
      },
      hint: 'Select a course',
    );
  }
}
