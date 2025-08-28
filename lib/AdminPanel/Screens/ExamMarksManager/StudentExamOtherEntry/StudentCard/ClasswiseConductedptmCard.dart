import 'package:flutter/material.dart';

class ClasswiseConductedptmCard extends StatelessWidget {
  final String courseId;
  final String courseName;
  final TextEditingController conductedptmController;

  const ClasswiseConductedptmCard({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.conductedptmController,
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
          // Course Info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course ID: $courseId",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  courseName,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Attendance Input
          Expanded(
            flex: 1,
            child: Container(

              height: 36,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: conductedptmController,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
