import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentAttendaceReports extends StatefulWidget {
  @override
  State<StudentAttendaceReports> createState() {
    return _StudentAttendaceReports();
  }
}

class _StudentAttendaceReports extends State<StudentAttendaceReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Attendance Reports', routeName: 'back'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Student Attendance Report',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 1
            ReportCardBox(
              icon: Icons.description,
              title: 'Day Wise Student Attendance Report',
              onTap: () {
               context.pushNamed('day-wise-student-attendance-reports');
              },
            ),
            const SizedBox(height: 12),
            // Card 2
            ReportCardBox(
              icon: Icons.event_note,
              title: 'Class/Course Attendance Report',
              onTap: () {
                context.pushNamed('course-wise-student-attendance-reports');
              },
            ),
          ],
        ),
      ),
    );
  }

}
