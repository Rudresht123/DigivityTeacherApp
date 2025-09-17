import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Helpers/StudentsData.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );
      final courseList = dashboardProvider.courseDropdownMap ?? [];

      if (courseList.isNotEmpty) {
        final allIds = courseList.map((e) => e['id']?.toString()).toSet();
        final firstCourseId = courseList.first['id']?.toString() ?? '';

        setState(() {
          if (widget.initialValue != null &&
              allIds.contains(widget.initialValue.toString())) {
            selectedCourse = widget.initialValue.toString();
          } else {
            selectedCourse = "";
          }
        });

        // **Initial fetch if isSubject is true and initial course is selected**
        if ((widget.isSubject ?? false) &&
            selectedCourse != null &&
            selectedCourse!.isNotEmpty) {
          showLoaderDialog(context);
          try {
            if (widget.forData == "students") {
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
            showBottomMessage(context, "$e", true);
          } finally {
            hideLoaderDialog(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final List<Map<String, dynamic>> rawList = dashboardProvider
        .courseDropdownMap
        .map(
          (e) => {
            'id': e['id']?.toString() ?? '',
            'value': e['value'] ?? 'Unknown',
            'count': e['count'] ?? '0',
          },
        )
        .toList();

    final List<Map<String, dynamic>> courseList = [
      {'id': '', 'value': 'Please Select Course', 'count': null},
      ...rawList,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedCourse,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: "Choose a course",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: widget.validator != null
              ? (String? val) => widget.validator!(val) as String?
              : null,
          selectedItemBuilder: (context) {
            return courseList.map((course) {
              final text = course['value'] ?? '';
              final count = course['count'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (count != null)
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            }).toList();
          },
          items: courseList.map((course) {
            final text = course['value'] ?? '';
            final count = course['count'];
            return DropdownMenuItem<String>(
              value: course['id'],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (count != null)
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) async {
            setState(() {
              selectedCourse = value;
            });

            if ((widget.isSubject ?? false) &&
                selectedCourse != null &&
                selectedCourse!.isNotEmpty) {
              showLoaderDialog(context);
              try {
                if (widget.forData == "students") {
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
                showBottomMessage(context, "$e", true);
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
