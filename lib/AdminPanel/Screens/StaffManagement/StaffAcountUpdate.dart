import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/ApisController/StaffApis.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Providers/StaffDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void StaffAcountUpdate(BuildContext context, int staffId, int staffstatus, Function(List<StaffModel>) onUpdateList) {

  TextEditingController _remarController =TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Inactive Staff !!"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // <-- Important!
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to inactivate the staff?"),
              SizedBox(height: 20),
              TextField(
                controller: _remarController,
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
            onPressed: () async {
              showLoaderDialog(context);

              final result = await StaffApis().updateStaffAcount(
                staffId,
                staffstatus,
                _remarController.text.trim(),
              );
              hideLoaderDialog(context);
              if (result != null && result['result'] == 1) {
                final provider = Provider.of<StaffDataProvider>(context, listen: false);
                provider.removeStaffById(staffId.toString());


                onUpdateList(provider.staffs);

                _remarController.clear();

                showBottomMessage(context, result['message'], false);

                Navigator.pop(context);
              } else {
                showBottomMessage(context, result['message'], true);
              }
            },
            icon: Icon(Icons.check, color: Colors.white),
            label: Text("OK"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),

        ],
      );
    },
  );
}
