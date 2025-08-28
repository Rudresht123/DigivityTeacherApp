import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/AttendanceStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/GradeModel.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:flutter/material.dart';

class StudentHeightWeightCard extends StatelessWidget {
  final String admissionNo;
  final String studentName;
  final String fatherName;
  final String profileImg;
  final TextEditingController studentHeightController;
  final TextEditingController studentWeightController;

  const StudentHeightWeightCard({
    super.key,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.profileImg,
    required this.studentHeightController,
    required this.studentWeightController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile
              PopupNetworkImage(imageUrl:profileImg),
              const SizedBox(width: 10),

              // Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admission Number: $admissionNo",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Student Name : $studentName",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Father Name : $fatherName",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),

            ],
          ),
         Divider(),
         Container(
           padding: EdgeInsets.all(10),
           margin: EdgeInsets.symmetric(vertical: 10),
           decoration: BoxDecoration(
             color: Colors.grey.shade50,
             border: Border.all(color: Colors.grey,width: 1),
             borderRadius: BorderRadius.circular(10)
           ),
           child:  Row(
             children: [
               Expanded(
                 flex: 2,
                 child: TextField(
                   controller: studentHeightController,
                   textAlign: TextAlign.center,
                   style: const TextStyle(fontSize: 14),
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(
                     hintText: 'Height In cm',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                   ),
                 ),
               ),
               SizedBox(width: 10,),
               Expanded(
                 flex: 2,
                 child: TextField(
                   controller: studentWeightController,
                   textAlign: TextAlign.center,
                   style: const TextStyle(fontSize: 14),
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(
                     hintText: 'Weight Im kg',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                   ),
                 ),
               ),
             ],
           ),
         )
        ],
      ),
    );
  }
}
