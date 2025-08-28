import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseWiseAttendaceReport extends StatefulWidget {
  @override
  State<CourseWiseAttendaceReport> createState() {
    return _CourseWiseAttendaceReport();
  }
}

class _CourseWiseAttendaceReport extends State<CourseWiseAttendaceReport> {
  TextEditingController _reportdate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Course Wise Student Attendance Reports',
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
                        if (_reportdate != null) {
                          context.pushNamed(
                            'coursewise-student-attendance-report',
                            pathParameters: {
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


