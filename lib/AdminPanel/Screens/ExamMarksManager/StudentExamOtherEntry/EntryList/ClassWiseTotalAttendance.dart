import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ClassTotalAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentTotalAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentCard/ClassAttendanceCard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentCard/StudentAttendance.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';

import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentExamOtherEntryHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassWiseTotalAttendance extends StatefulWidget {
  final String? courseId;
  final int examTermId;
  final String? course;
  final String? examTerm;
  ClassWiseTotalAttendance({
    required this.courseId,
    required this.examTermId,
    this.course,
    this.examTerm,
  });
  @override
  State<ClassWiseTotalAttendance> createState() {
    return _ClassWiseTotalAttendance();
  }
}

class _ClassWiseTotalAttendance extends State<ClassWiseTotalAttendance> {
  Map<String, TextEditingController> AttendanceControllers = {};
  String? userId;
  List<ClassTotalAttendanceModel> classList = [];

  @override
  void initState() {
    super.initState(); // Always call this first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStudentList();
    });
  }

  Future<void> getStudentList() async {
    final bodydata = {
      "course_id": widget.courseId.toString(),
      "exam_term_id":widget.examTermId.toString()
    };

    final response = await StudentExamOtherEntryHelper()
        .apiclasswisetotalattendance(bodydata);

    if (response != null) {
      setState(() {
        classList = response;
        for (var cls in classList) {
          AttendanceControllers[cls.key.toString()] = TextEditingController(
            text: cls.classTotalAttendance.toString(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kTextTabBarHeight),
        child: SimpleAppBar(
          titleText: 'Class Wise Total Attendance',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow("Class/Course", widget.course ?? ''),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoRow("Exam Term", widget.examTerm ?? ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            Expanded(
              child: classList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  final classItem = classList[index];
                  final controller = AttendanceControllers[classItem.key.toString()]!;
                  return ClassAttendanceCard(
                    courseId: classItem.key.toString(),
                    courseName: classItem.value.toString(),
                    attendanceController: controller,
                  );
                },
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
            text: 'Save Marks',
            icon: Icons.save,
            onPressed: () async {
              showLoaderDialog(context);
              final List<Map<String, dynamic>> updatedatalist = [];

              for (var classItem in classList) {
                final classId = classItem.key.toString();
                final attendanceValue = AttendanceControllers[classId]?.text ?? '0';
                final userId = (await SharedPrefHelper.getPreferenceValue('user_id'))?.toString() ?? "";

                updatedatalist.add({
                  "user_id":userId,
                  "course_section_id": classId,
                  "total_days": attendanceValue,
                });
              }

              final Map<String, dynamic> bodydata = {
                'exam_term_id': widget.examTermId,
                'updatedatalist': updatedatalist,
              };

              final response = await StudentExamOtherEntryHelper().storeClassWiseAttendance(bodydata);
              hideLoaderDialog(context);

              if (response['result'] == 1) {
                getStudentList();
                showBottomMessage(context, response['message'], false);
              } else {
                showBottomMessage(context, response['message'], true);
              }
            }


        ),
      ),
    );
  }

}

Widget _buildInfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$title ",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 2,

          child: Row(
            children: [
              Text(": "),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    "$value",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
