import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/AttendanceStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/GradeModel.dart';
import 'package:flutter/material.dart';

class StudentMarksCard extends StatelessWidget {
  final String admissionNo;
  final String studentName;
  final String fatherName;
  final String markingtype;
  final String profileImg;
  final TextEditingController marksController;
  final String attendance;
  final List<GradeModel> gradeList;
  final List<AttendanceStatusModel> attendanceOptions;
  final void Function(String?) onAttendanceChanged;

  const StudentMarksCard({
    super.key,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.profileImg,
    required this.marksController,
    required this.attendance,
    required this.onAttendanceChanged,
    required this.attendanceOptions,
    required this.gradeList,
    required this.markingtype,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile
          PopupNetworkImage(imageUrl: profileImg),
          const SizedBox(width: 5),

          // Info
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adm No.: $admissionNo",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  studentName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "D/O : $fatherName",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // MARKS & ATTENDANCE
          Expanded(
            flex: 0,
            child: Row(
              children: [
                // Marks
                SizedBox(
                  width: 70,
                  height: 36,
                  child: markingtype == 'm'
                      ? TextField(
                    controller: marksController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'ex.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                  )
                      : SizedBox(
                    width: 70,
                    height: 36,
                    child: DropdownButtonFormField<String>(
                      value: gradeList.map((e) => e.key).contains(marksController.text)
                          ? marksController.text
                          : null,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text('Sel'),
                      items: gradeList.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (selectedKey) {
                        if (selectedKey != null) {
                          marksController.text = selectedKey;
                        }
                      },
                    )
                    ,
                  ),
                ),
                const SizedBox(width: 5),

                // Attendance Dropdown
                SizedBox(
                  width: 60,
                  height: 36,
                  child: DropdownButtonFormField<String>(
                    value: attendance.isNotEmpty ? attendance : null,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hint: const Text('Att.'),
                    items: attendanceOptions.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.key.toUpperCase()), // show P, A, L
                      );
                    }).toList(),
                    onChanged: onAttendanceChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
