import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DayWiseAttendanceReport extends StatefulWidget {
  @override
  State<DayWiseAttendanceReport> createState() {
    return _DayWiseAttendanceReport();
  }
}

class _DayWiseAttendanceReport extends State<DayWiseAttendanceReport> {
  late String selectedCourseId;
  TextEditingController _reportdate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Day Wise Student Attendance Reports',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CourseComponent(
                      initialValue: '',
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Course";
                        }
                        selectedCourseId = value;
                      },
                      onChanged: (val) {
                        selectedCourseId = val;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    DatePickerField(
                      controller: _reportdate,
                      label: 'Attendance Date',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Student Date of Birth.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),
                    CustomBlueButton(
                      width: double.infinity,
                      text: "Get Result",
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        if (selectedCourseId.isNotEmpty && _reportdate != null) {

                          context.pushNamed(
                            'daywise-student-attendance-report',
                            pathParameters: {
                              'course_id': selectedCourseId,
                              'reportdate': _reportdate.text.toString(),
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select course and date")),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


