import 'dart:async';

import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/ShortByDropdown.dart';
import 'package:digivity_admin_app/Components/StudentSortBy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class StudentAttendanceFillterForm extends StatefulWidget {
  const StudentAttendanceFillterForm({super.key});

  @override
  State<StudentAttendanceFillterForm> createState() => _StudentAttendanceFillterForm();
}

class _StudentAttendanceFillterForm extends State<StudentAttendanceFillterForm> {
  String? selectedCourseId;
  String? selectedSortBy;
  String? selectedStudentSort;
  TextEditingController _selectedDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Search Student List",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // COURSE SELECTOR
                    CourseComponent(
                      initialValue: '',
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Course";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        selectedCourseId=val;
                        setState(() {

                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // SORT FIELD (like admission_no, name, etc.)
                    ShortByDropdown(
                      onChanged: (value) {
                        setState(() {
                          selectedSortBy = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // OPTIONAL: STUDENT-SPECIFIC SORTING
                    Studentsortby(
                      onChanged: (value) {
                        setState(() {
                          selectedStudentSort = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // OPTIONAL: STATUS FILTER
                    DatePickerField(
                      label: 'Attendance Date',
                      controller:_selectedDateController,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: CustomBlueButton(
          text: 'Search',
          icon: Icons.search,
            onPressed: () {
            print(selectedCourseId);
            print(selectedSortBy);
              if (selectedCourseId != null && selectedSortBy != null) {
                // Delay push until the next frame
                  context.pushNamed(
                    'student-attendance-list',
                    extra: {
                      'course_id': selectedCourseId,
                      'selectedSortBy': selectedSortBy,
                      'selectedDate': _selectedDateController.text,
                    },
                  );

              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select Course and Sort By"),
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
