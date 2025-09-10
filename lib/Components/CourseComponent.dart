import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Helpers/StudentsData.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart'; // import your custom dropdown

class CourseComponent extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(dynamic)? validator;
  final bool? isSubject;
  final String? forData;
  final Function(List<SubjectModel>)? onSubjectListChanged;
  final Function(List<StudentModel>)? onStudentListChanged;

  const CourseComponent({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.isSubject,
    this.onSubjectListChanged,
    this.onStudentListChanged,
    this.forData,
  }) : super(key: key);

  @override
  State<CourseComponent> createState() => _CourseComponentState();
}

class _CourseComponentState extends State<CourseComponent> {
  String? selectedCourse;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );
      final courseList = dashboardProvider.courseDropdownMap ?? [];

      if (courseList.isNotEmpty) {
        final firstCourseId = courseList.first['id'];
        if (firstCourseId != null) {
          setState(() {
            selectedCourse = widget.initialValue ?? firstCourseId;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final List<Map<String, String>> rawList =
        dashboardProvider.courseDropdownMap;

    // Add default option at the top
    final List<Map<String, dynamic>> courseList = [
      {'id': '', 'value': 'Please Select Course'}, // Avoid null here
      ...rawList.map(
        (e) => {
          'id': e['id'] ?? '',
          'value': e['value'] ?? 'Unknown',
          'count': e['count'] ?? '0',
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          items: courseList,
          displayKey: 'value',
          valueKey: 'id',
          validator: widget.validator != null
              ? (val) => widget.validator!(val)
              : null,
          hint: "Choose a course",
          selectedValue: selectedCourse,
          onChanged: (value) async {
            setState(() {
              selectedCourse = value;
            });

            if ((widget.isSubject ?? false) &&
                selectedCourse != null &&
                selectedCourse!.isNotEmpty) {
              showLoaderDialog(context);
              try {
                if (widget.forData! == "students") {
                  final students = await StudentsData().fetchStudents(
                    courseId: selectedCourse,
                    sortByMethod: "asc",
                    orderByMethod: "roll_no",
                    selectedStatus: "active",
                  );
                  widget.onStudentListChanged?.call(students);
                } else if (widget.forData == "subjects") {
                  final subjects = await CustomFunctions().getCourseSubjects(
                    selectedCourse!,
                  );
                  widget.onSubjectListChanged?.call(subjects);
                }
              } catch (e) {
                print("${e}");
                showBottomMessage(context, "${e}", true);
              } finally {
                hideLoaderDialog(context);
              }
            }
            if (value != null) {
              widget.onChanged?.call(value);
            }
          },
        ),
      ],
    );
  }
}
