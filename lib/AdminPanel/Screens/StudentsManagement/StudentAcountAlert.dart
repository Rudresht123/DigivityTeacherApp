import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Providers/StudentDataProvider.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void showStudentAlertDialog(BuildContext context,String studentId,String studentStatus) {
  TextEditingController _remarController =TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Inactive Student !!"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // <-- Important!
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to inactivate the student?"),
              SizedBox(height: 20),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Your Message',
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);// Your logic here
            },
            icon: Icon(Icons.cancel, color: Colors.white),
            label: Text("NO"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,   // Button background color
              foregroundColor: Colors.white,   // Text & icon color
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async{
              showLoaderDialog(context);
              final result = await CustomFunctions().updateStudentAcount(studentId, studentStatus, _remarController.text.trim());
              if (result != null && result['result'] == 1) {
                // Call provider to remove student
                Provider.of<StudentDataProvider>(context, listen: false).removeStudentById(studentId);
                hideLoaderDialog(context);
                _remarController.text='';
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.check, color: Colors.white),
            label: Text("OK"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,   // Button background color
              foregroundColor: Colors.white,   // Text & icon color
            ),
          ),

        ],
      );
    },
  );
}
