import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/AttendanceStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/GradeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentListMarksEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentMarksCard.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentListFormMarksEntry extends StatefulWidget {
  late final String? course;
  late final String? examtype;
  late final String? examterm;
  late final String? assessment;
  late final String? Subject;
  late final String? courseId;
  late final int? examtypeId;
  late final int? examtermId;
  late final int? assessmentId;
  late final int? SubjectId;
  StudentListFormMarksEntry({
    required this.courseId,
    required this.examtypeId,
    required this.examtermId,
    required this.course,
    required this.assessment,
    required this.assessmentId,
    required this.examterm,
    required this.examtype,
    required this.Subject,
    required this.SubjectId,
  });

  @override
  State<StudentListFormMarksEntry> createState() {
    return _StudentListFormMarksEntry();
  }
}

class _StudentListFormMarksEntry extends State<StudentListFormMarksEntry> {
  Map<String, TextEditingController> marksControllers = {};

  List<StudentListMarksEntry> studentList = [];
  List<GradeModel> gradeList = [];
  List<AttendanceStatusModel> attendanceStatusList = [];
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
      "exam_term_id": widget.examtermId,
      "exam_type_id": widget.examtypeId,
      "exam_assessment_id": widget.assessmentId,
      "subject_id": widget.SubjectId,
    };

    final response = await StudentMarksManagerCommonHelper()
        .apistudentlistmarksentry(bodydata);

    if (response != null) {
      setState(() {
        studentList = response.studentList;
        gradeList = response.gradeList;
        attendanceStatusList = response.attendanceStatus;

        // Initialize controllers
        for (var student in studentList) {
          marksControllers[student.studentId.toString()] =
              TextEditingController(text: student.marks.toString() ?? '');
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Student Marks Entry',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Top Exam Info
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
                        child: _buildInfoRow(
                          "Class/Course",
                          widget.course ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoRow(
                          "Exam Term",
                          widget.examterm ?? '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          "Exam Type",
                          widget.examtype ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoRow(
                          "Assessment",
                          widget.assessment ?? '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow("Subject", widget.Subject ?? ''),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// Student List
            Expanded(
              child: studentList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      itemCount: studentList.length,
                      itemBuilder: (context, index) {
                        final student = studentList[index];
                        final marksController = marksControllers[student.studentId.toString()]!;
                        return StudentMarksCard(
                          admissionNo: student.admissionNo.toString(),
                          studentName: student.studentName,
                          fatherName: student.fatherName,
                          profileImg: student.profileImg,
                          marksController: marksController,
                          markingtype: student.markingType,
                          attendance: student.attendStatus,
                          gradeList: gradeList,
                          attendanceOptions: attendanceStatusList,
                          onAttendanceChanged: (value) {
                            setState(() {
                              student.attendStatus = value ?? 'P';
                            });
                          },
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
          text: 'Save Marks',
          icon: Icons.save,
            onPressed: () async{
            // showLoaderDialog(context);
              final List<Map<String, dynamic>> updatedatalist = [];

              for (var student in studentList) {
                final studentId = student.studentId.toString();
                final marks = marksControllers[student.studentId.toString()]!;
                final markingType = student.markingType.toString();
                final attendance = student.attendStatus;
                updatedatalist.add({
                  "student_id": studentId,
                  "marks": marks.text.isEmpty ? null : marks.text,
                  "marking_type": markingType,
                  "attendance_status": attendance,
                });
              }

              final Map<String, dynamic> bodydata = {
                'course_section_id': widget.courseId,       // example: '1@1'
                'exam_term_id': widget.examtermId,
                'exam_type_id': widget.examtypeId,
                'exam_assessment_id': widget.assessmentId,
                'subject_id': widget.SubjectId,
                'updatedatalist': updatedatalist,
              };
              final response =await StudentMarksManagerCommonHelper().storeStudentMarks(bodydata!);
              hideLoaderDialog(context);
              if(response['result']==1){
                getStudentList();
                showBottomMessage(context, response['message'], false);
              }else{
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
