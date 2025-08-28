import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/AttendanceStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/GradeModel.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:flutter/material.dart';

class StudentAttendance extends StatelessWidget {
  final String admissionNo;
  final String studentName;
  final String fatherName;
  final String profileImg;
  final TextEditingController attendanceControllers;


  const StudentAttendance({
    super.key,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.profileImg,
    required this.attendanceControllers,
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
          PopupNetworkImage(imageUrl:profileImg),
          const SizedBox(width: 10),

          // Info
          Expanded(
            flex: 3,
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
                  "S/O : $fatherName",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

         Expanded(
             flex: 1,
             child:   Container(
               width: 70,
               height: 36,
               decoration: BoxDecoration(
                 color: Colors.green.shade50,
                 borderRadius: BorderRadius.circular(10)
               ),
               child: TextField(
               controller: attendanceControllers,
               textAlign: TextAlign.center,
               style: const TextStyle(fontSize: 14),
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                 hintText: 'Ex. 1',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8),
                 ),
                 contentPadding: const EdgeInsets.symmetric(horizontal: 1),
               ),
             ),))
          // MARKS & ATTENDANCE

        ],
      ),
    );
  }
}
