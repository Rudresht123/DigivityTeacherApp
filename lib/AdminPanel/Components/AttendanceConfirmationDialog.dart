import 'package:flutter/material.dart';

class AttendanceConfirmationDialog extends StatelessWidget {
  final int lateMinutes;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String attendanceType;

  const AttendanceConfirmationDialog({
    Key? key,
    required this.lateMinutes,
    required this.onConfirm,
    required this.onCancel,
    required this.attendanceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm Attendance"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          attendanceType == 'punchin' ?
          Text("Attendance Punch In Submit!!") : Text("Attendance Punch Out Submit !!"),
          SizedBox(height: 10),
          Text("Please check your details."),
          if (lateMinutes >= 1) ...[
            SizedBox(height: 10),
            Text(
              "You are running $lateMinutes minutes late compared to the Scheduled Time.",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to ${attendanceType == 'punchin' ? 'Punch In' : 'Punch Out'}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onCancel,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close, // Cross icon
                color: Colors.white,
              ),
              SizedBox(width: 8), // Icon aur text ke beech gap
              Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onConfirm,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close, // Cross icon
                color: Colors.white,
              ),
              SizedBox(width: 8), // Icon aur text ke beech gap
              Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )


      ],
    );
  }
}
