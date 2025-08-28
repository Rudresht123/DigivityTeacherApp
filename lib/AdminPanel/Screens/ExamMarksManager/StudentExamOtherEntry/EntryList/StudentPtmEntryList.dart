import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentPtmListModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentTotalAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentCard/StudentAttendance.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentCard/StudentPtmEntryCard.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';

import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentExamOtherEntryHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentPtmEntryList extends StatefulWidget {
  final String courseId;
  final int examTermId;
  final String? course;
  final String? examTerm;
  StudentPtmEntryList({
    required this.courseId,
    required this.examTermId,
    this.course,
    this.examTerm,
  });
  @override
  State<StudentPtmEntryList> createState() {
    return _StudentPtmEntryList();
  }
}

class _StudentPtmEntryList extends State<StudentPtmEntryList> {
  Map<String, TextEditingController> ptmControllers = {};

  List<StudentPtmListModel> studentList = [];

  @override
  void initState() {
    super.initState(); // Always call this first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStudentList();
    });
  }

  Future<void> getStudentList() async {
    final bodydata = {
      "course_section_id": widget.courseId,
      "exam_term_id": widget.examTermId,
    };
    final response = await StudentExamOtherEntryHelper()
        .getStudentTotalAttendPtm(bodydata);
    if (response != null) {
      setState(() {
        studentList = response;
        // Initialize controllers
        for (var student in studentList) {
          ptmControllers[student.studentId.toString()] =
              TextEditingController(text: student.totalAttPtm?.toString() ?? '');
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
          titleText: 'Student Total Attend PTM',
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
              child: studentList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  final student = studentList[index];
                  final PTMControllers = ptmControllers[student.studentId.toString()]!;
                  return StudentPtmEntryCard(
                    admissionNo: student.admissionNo ?? '',
                    studentName: student.studentName,
                    fatherName: student.fatherName,
                    profileImg: student.profileImg ?? '',
                    ptmControllers: PTMControllers,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
            text: 'Save Attend PTM',
            icon: Icons.save,
            onPressed: () async{
              showLoaderDialog(context);
              final List<Map<String, dynamic>> updatedatalist = [];

              for (var student in studentList) {
                final studentId = student.studentId.toString();
                final totalattendptm = ptmControllers[student.studentId.toString()]!;
                final userId = (await SharedPrefHelper.getPreferenceValue('user_id'))?.toString() ?? "";

                updatedatalist.add({
                  "user_id":userId,
                  "student_id": studentId,
                  "total_attend_ptm": totalattendptm.text.isEmpty ? null : totalattendptm.text,
                });
              }

              final Map<String, dynamic> bodydata = {
                'course_section_id': widget.courseId,
                'exam_term_id': widget.examTermId,
                'updatedatalist': updatedatalist,
              };
              final response =await StudentExamOtherEntryHelper().storeStudentTotalAttendptm(bodydata!);
              if(response['result']==1){
                getStudentList();
                showBottomMessage(context, response['message'], false);
              }
              else{
                showBottomMessage(context, response['message'], true);
              }
              hideLoaderDialog(context);
              
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
