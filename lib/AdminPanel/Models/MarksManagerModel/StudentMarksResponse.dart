import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/AttendanceStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/GradeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentListMarksEntry.dart';

class StudentMarksResponse {
  final List<StudentListMarksEntry> studentList;
  final List<GradeModel> gradeList;
  final List<AttendanceStatusModel> attendanceStatus;

  StudentMarksResponse({
    required this.studentList,
    required this.gradeList,
    required this.attendanceStatus,
  });

  factory StudentMarksResponse.fromJson(Map<String, dynamic> json) {
    return StudentMarksResponse(
      studentList: (json['studentlist'] as List)
          .map((e) => StudentListMarksEntry.fromJson(e))
          .toList(),
      gradeList: (json['gradelist'] as List)
          .map((e) => GradeModel.fromJson(e))
          .toList(),
      attendanceStatus: (json['attend_status'] as List)
          .map((e) => AttendanceStatusModel.fromJson(e))
          .toList(),
    );
  }
}
