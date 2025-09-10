import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffLeaveRecordModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffLeaveModule/StaffLeaveRecordBottomSheet.dart';
import 'package:digivity_admin_app/Components/Badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffLeaveRecordCard extends StatefulWidget {
  StaffLeaveRecordModel? leaverecord;
  VoidCallback? onReferesh;

  StaffLeaveRecordCard({Key? key, required this.leaverecord,this.onReferesh});
  @override
  State<StatefulWidget> createState() {
    return _StudentLeaveCard();
  }
}

class _StudentLeaveCard extends State<StaffLeaveRecordCard> {
  @override
  Widget build(BuildContext context) {
    final leave = widget.leaverecord;
    return InkWell(
      onTap: () {
        StaffLeaveRecordBottomSheet(context, {
          'profileImage': leave.leaveApplyByProfile,
          "leaveApplyBy": leave.leaveApplyBy,
          "lvapplyDate": leave.applyDate,
          "lvStatus": leave.lvStatus,
          "apply_date":leave.applyDate,
          "attachment":leave.attachment
        }, leave,widget.onReferesh);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with profile and date
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PopupNetworkImage(
                    imageUrl: "${leave!.leaveApplyByProfile}",
                    radius: 25,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Leave Apply By',
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          "${leave.leaveApplyBy}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Leave Status",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        BadgeScreen(
                          fontSize: 11,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          text: "${leave.lvStatus}",
                          color: leave.lvStatus == "Cancel"
                              ? Colors.red
                              : leave.lvStatus == "Pending"
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.8),
              const SizedBox(height: 16),

              /// Notice Title and Description Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Section Start Here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${leave.lvTitle}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${leave.applyDate}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1),
                    SizedBox(height: 10),
                    Text(
                      "Leave Description  : ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${leave.lvDescription}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
