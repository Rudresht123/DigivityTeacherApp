import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendance/AttendanceStatusButton.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Providers/StudentAttendanceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentMarkAttendance extends StatefulWidget {
  final String courseId;
  final String? selectedSortBy;
  final String selectedDate;

  const StudentMarkAttendance({
    required this.courseId,
    this.selectedSortBy,
    required this.selectedDate,
    super.key,
  });

  @override
  State<StudentMarkAttendance> createState() => _StudentMarkAttendance();
}

class _StudentMarkAttendance extends State<StudentMarkAttendance> {
  List<StudentAttendanceModel> _students = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    showLoaderDialog(context);
    try {
      final provider = Provider.of<StudentAttendanceProvider>(
        context,
        listen: false,
      );
      await provider.fetchAttendanceList(
        courseId: widget.courseId,
        selectedSortBy: widget.selectedSortBy ?? 'roll_no',
        selectedDate: widget.selectedDate,
      );
      setState(() {
        _students = provider.attendanceList;
      });
    } catch (e) {
      print("${e}");
      showBottomMessage(context, "${e}", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  final statusColorMap = {
    'P': const Color(0xFFDBF3E2),
    'A': Colors.red.shade50,
    'LT': Colors.orange.shade50,
    'LV': Colors.blue.shade50,
  };

  @override
  Widget build(BuildContext context) {
    String? StudentStatus;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Mark Attendance [${widget.selectedDate}]",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Expanded(
                  child: _students.isNotEmpty
                      ? ListView.separated(
                          itemCount: _students.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.shade300, height: 1),
                          itemBuilder: (context, index) {
                            final student = _students[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    statusColorMap[student.attendance
                                        .toUpperCase()] ??
                                    Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  PopupNetworkImage(
                                    imageUrl: student.profileImg,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Adm No.: ${student.admissionNo} | Roll No.: ${student.rollNo ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${student.studentName} (${student.course})",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "D/O : ${student.fatherName}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF514197,
                                      ).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: AttendanceStatusButton(
                                      initialStatus: student.attendance
                                          .toUpperCase(),
                                      onStatusChanged: (status) {
                                        StudentStatus = status;
                                        Provider.of<StudentAttendanceProvider>(
                                          context,
                                          listen: false,
                                        ).updateAttendanceStatus(
                                          student.studentId,
                                          status,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No students found")),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
          text: 'Submit',
          icon: Icons.check,
          onPressed: () async {
            showLoaderDialog(context);
            final provider = Provider.of<StudentAttendanceProvider>(
              context,
              listen: false,
            );
            final courseId = widget.courseId;
            final List<Map<String, dynamic>> dataList = _students.map((
              student,
            ) {
              return {
                "student_id": student.studentId,
                "att_date": widget.selectedDate,
                "current_status": student.attendance.toUpperCase(),
              };
            }).toList();
            final payload = {
              "attendancesubmitted_classSec": "$courseId",
              "data": dataList,
            };
            final isSuccess = await provider.submitAttendanceData(payload);
            showBottomMessage(context, isSuccess, false);
          },
        ),
      ),
    );
  }
}
